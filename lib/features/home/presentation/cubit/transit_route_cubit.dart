import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/features/home/data/models/transit_route.dart';
import 'package:linos/features/home/data/services/google_directions_api_service.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_state.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';
import 'transit_route_state.dart';

class TransitRouteCubit extends Cubit<TransitRouteState> {
  final GoogleDirectionsApiService _directionsApiService;
  final SearchDestinationCubit _searchDestinationCubit;
  final HomeMapCubit _homeMapCubit;

  StreamSubscription<SearchDestinationState>? _searchSubscription;
  StreamSubscription<HomeMapState>? _mapSubscription;

  TransitRouteCubit(this._directionsApiService, this._searchDestinationCubit, this._homeMapCubit)
    : super(TransitRouteInitial()) {
    _listenToSearchDestination();
    _listenToMapLocation();
  }

  LatLng? _currentUserLocation;
  LatLng? _selectedDestination;

  void _listenToSearchDestination() {
    _searchSubscription = _searchDestinationCubit.stream.listen((state) {
      if (state is SearchDestinationSelected) {
        _selectedDestination = state.selectedPlace.coordinates;
        _fetchRouteIfReady();
      } else if (state is SearchDestinationInitial) {
        _selectedDestination = null;
        clearRoute();
      }
    });
  }

  void _listenToMapLocation() {
    _mapSubscription = _homeMapCubit.stream.listen((state) {
      if (state is HomeMapLocationLoaded) {
        final newLocation = state.userLocation;
        // Only fetch route if user location actually changed
        if (_currentUserLocation == null ||
            _currentUserLocation!.latitude != newLocation.latitude ||
            _currentUserLocation!.longitude != newLocation.longitude) {
          _currentUserLocation = newLocation;
          _fetchRouteIfReady();
        }
      }
    });
  }

  void _fetchRouteIfReady() {
    if (_currentUserLocation != null && _selectedDestination != null) {
      fetchRoute(origin: _currentUserLocation!, destination: _selectedDestination!);
    }
  }

  Future<void> fetchRoute({required LatLng origin, required LatLng destination, DateTime? departureTime}) async {
    if (isClosed) return;

    emit(TransitRouteLoading());

    try {
      final routes = await _directionsApiService.getTransitDirections(
        origin: origin,
        destination: destination,
        departureTime: departureTime,
      );

      if (isClosed) return;

      if (routes.isNotEmpty) {
        emit(TransitRouteLoaded(route: routes.first, alternativeRoutes: routes.skip(1).toList()));
      } else {
        emit(const TransitRouteError(message: 'error_no_routes_found'));
      }
    } catch (e) {
      if (isClosed) return;

      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(TransitRouteError(message: errorKey));
    }
  }

  void clearRoute() {
    if (isClosed) return;
    emit(TransitRouteCleared());
  }

  void selectAlternativeRoute(int routeIndex) {
    final currentState = state;
    if (currentState is TransitRouteLoaded && routeIndex < currentState.alternativeRoutes.length) {
      final newMainRoute = currentState.alternativeRoutes[routeIndex];
      final newAlternatives = List.from(currentState.alternativeRoutes).cast<TransitRoute>()
        ..removeAt(routeIndex)
        ..insert(0, currentState.route);

      emit(TransitRouteLoaded(route: newMainRoute, alternativeRoutes: newAlternatives));
    }
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    _mapSubscription?.cancel();
    return super.close();
  }
}

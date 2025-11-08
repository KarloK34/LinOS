import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/features/home/data/enums/route_segment_type.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';
import 'package:linos/features/home/data/models/transit_route.dart';

class HomeMapCubit extends Cubit<HomeMapState> {
  HomeMapCubit() : super(HomeMapInitial()) {
    // Defer location fetching to avoid blocking initialization
    Future.microtask(() => fetchUserLocation());
  }

  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void animateCameraToLocation(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 14.0)));
  }

  Future<void> fetchUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      if (isClosed) return;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (isClosed) return;
        emit(const HomeMapLocationError('location_services_disabled'));
        return;
      }

      if (isClosed) return;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        if (isClosed) return;
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (isClosed) return;
          emit(const HomeMapLocationError('location_permissions_denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (isClosed) return;
        emit(const HomeMapLocationError('location_permissions_denied_forever'));
        return;
      }

      if (isClosed) return;
      Position position = await Geolocator.getCurrentPosition();

      final userLocation = LatLng(position.latitude, position.longitude);
      final userCameraPosition = CameraPosition(target: userLocation, zoom: 14);

      if (isClosed) return;
      emit(HomeMapLocationLoaded(userLocation: userLocation, initialCameraPosition: userCameraPosition));
    } catch (e, stackTrace) {
      if (isClosed) return;
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(HomeMapLocationError(errorKey, originalError: e));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  void showUserLocationOnMap() {
    if (state is HomeMapLocationLoaded) {
      final loadedState = state as HomeMapLocationLoaded;
      animateCameraToLocation(loadedState.userLocation);
    } else {
      fetchUserLocation();
    }
  }

  void updateTransitRoute(TransitRoute route) {
    if (state is HomeMapLocationLoaded) {
      final currentState = state as HomeMapLocationLoaded;

      final clearedPolylines = currentState.polylines.where((p) => !p.polylineId.value.startsWith('route_')).toList();

      final routePolylines = <Polyline>[];

      for (int i = 0; i < route.segments.length; i++) {
        final segment = route.segments[i];

        if (segment.polylinePoints.isNotEmpty) {
          Color polylineColor;
          int width;

          switch (segment.type) {
            case RouteSegmentType.walking:
              polylineColor = Colors.green;
              width = 4;
              break;
            case RouteSegmentType.transit:
              switch (segment.vehicleType?.toUpperCase()) {
                case 'BUS':
                  polylineColor = Colors.blue;
                  break;
                case 'TRAM':
                case 'LIGHT_RAIL':
                  polylineColor = Colors.red;
                  break;
                case 'SUBWAY':
                case 'RAIL':
                  polylineColor = Colors.purple;
                  break;
                default:
                  polylineColor = Colors.orange;
              }
              width = 6;
              break;
          }

          routePolylines.add(
            Polyline(
              polylineId: PolylineId('route_segment_$i'),
              points: segment.polylinePoints,
              color: polylineColor,
              width: width,
              patterns: segment.type == RouteSegmentType.walking ? [PatternItem.dash(10), PatternItem.gap(5)] : [],
            ),
          );
        }
      }

      final updatedPolylines = [...clearedPolylines, ...routePolylines];

      emit(
        HomeMapLocationLoaded(
          userLocation: currentState.userLocation,
          initialCameraPosition: currentState.initialCameraPosition,
          markers: currentState.markers,
          polylines: updatedPolylines,
        ),
      );
    }
  }

  void addDestinationMarker(LatLng destination, String title) {
    if (state is HomeMapLocationLoaded) {
      final currentState = state as HomeMapLocationLoaded;
      final destinationMarker = Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      final updatedMarkers = List<Marker>.from(currentState.markers)
        ..removeWhere((m) => m.markerId.value == 'destination')
        ..add(destinationMarker);

      emit(
        HomeMapLocationLoaded(
          userLocation: currentState.userLocation,
          initialCameraPosition: currentState.initialCameraPosition,
          markers: updatedMarkers,
          polylines: currentState.polylines,
        ),
      );
    }
  }

  void clearRoute() {
    if (state is HomeMapLocationLoaded) {
      final currentState = state as HomeMapLocationLoaded;
      final updatedPolylines = currentState.polylines.where((p) => !p.polylineId.value.startsWith('route_')).toList();
      final updatedMarkers = currentState.markers.where((m) => m.markerId.value != 'destination').toList();

      emit(
        HomeMapLocationLoaded(
          userLocation: currentState.userLocation,
          initialCameraPosition: currentState.initialCameraPosition,
          markers: updatedMarkers,
          polylines: updatedPolylines,
        ),
      );
    }
  }
}

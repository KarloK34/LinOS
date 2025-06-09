import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/core/services/osijek_transit_data_service.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/features/schedule/data/models/transit_stop.dart';
import 'package:linos/features/schedule/data/repositories/firebase_favorite_stops_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final FirebaseFavoriteStopsRepository _favoriteStopsRepository;

  ScheduleCubit(this._favoriteStopsRepository) : super(ScheduleInitial());

  Future<List<TransitStop>> getTramStops() async {
    final currentState = state;
    if (currentState is! ScheduleLoaded) return [];

    return currentState.tramStops;
  }

  Future<List<TransitStop>> getBusStops() async {
    final currentState = state;
    if (currentState is! ScheduleLoaded) return [];

    return currentState.busStops;
  }

  Future<void> loadStops() async {
    emit(ScheduleLoading());
    List<TransitStop> tramStops = OsijekTransitDataService.getTramStops();
    List<TransitStop> busStops = OsijekTransitDataService.getBusStops();

    try {
      final favoriteTramStops = await _favoriteStopsRepository.getFavoriteStopsByVehicleType(VehicleType.tram);
      final favoriteBusStops = await _favoriteStopsRepository.getFavoriteStopsByVehicleType(VehicleType.bus);
      emit(
        ScheduleLoaded(
          favoriteTramStops: favoriteTramStops,
          favoriteBusStops: favoriteBusStops,
          tramStops: tramStops,
          busStops: busStops,
        ),
      );
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(ScheduleError(errorKey, originalError: e));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> toggleFavoriteStop(TransitStop stop) async {
    final currentState = state;
    if (currentState is! ScheduleLoaded) return;

    try {
      final isFavorite = await _favoriteStopsRepository.isFavoriteStop(stop.id);

      if (isFavorite) {
        await _favoriteStopsRepository.removeFavoriteStop(stop);
      } else {
        await _favoriteStopsRepository.addFavoriteStop(stop);
      }

      final updatedFavorites = await _favoriteStopsRepository.getFavoriteStopsByVehicleType(stop.vehicleType);

      if (stop.vehicleType == VehicleType.tram) {
        emit(currentState.copyWith(favoriteTramStops: updatedFavorites));
      } else if (stop.vehicleType == VehicleType.bus) {
        emit(currentState.copyWith(favoriteBusStops: updatedFavorites));
      }
    } catch (e) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(ScheduleError(errorKey, originalError: e));
      AppErrorLogger.handleError(e, StackTrace.current);
    }
  }

  void selectStop(TransitStop stop) {
    final currentState = state;
    if (currentState is ScheduleLoaded) {
      emit(currentState.copyWith(selectedStop: stop));
    }
  }

  void clearSelectedStop() {
    final currentState = state;
    if (currentState is ScheduleLoaded) {
      emit(currentState.copyWith(selectedStop: null));
    }
  }
}

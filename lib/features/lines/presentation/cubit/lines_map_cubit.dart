import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/services/osijek_transit_data_service.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/features/lines/data/enums/line_type.dart';
import 'package:linos/features/lines/data/models/vehicle_position.dart';
import 'package:linos/features/lines/data/services/vehicle_simulation_service.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_state.dart';
import 'package:linos/features/lines/data/services/transit_lines_api_service.dart';

@lazySingleton
class LinesMapCubit extends Cubit<LinesMapState> {
  final TransitLinesApiService _transitLinesApiService;
  final VehicleSimulationService _vehicleSimulationService;

  LinesMapCubit(this._transitLinesApiService, this._vehicleSimulationService) : super(LinesMapInitial());

  GoogleMapController? _mapController;
  StreamSubscription<Map<String, List<VehiclePosition>>>? _vehicleSubscription;
  bool _showVehicles = false;
  LineType? _currentLineType;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> showTramLines() async {
    emit(LinesMapLoading());

    try {
      final apiTramRoutes = await _transitLinesApiService.getTramLines();
      final customTramRoutes = OsijekTransitDataService.getTramRoutes();
      final mergedRoutes = <String, List<LatLng>>{...apiTramRoutes, ...customTramRoutes};

      _currentLineType = LineType.tram;
      final tramPolylines = _createTramPolylines(mergedRoutes);

      if (_showVehicles) {
        _startVehicleSimulation(mergedRoutes, LineType.tram);
      }

      emit(LinesMapLoaded(polylines: tramPolylines, selectedType: LineType.tram, showVehicles: _showVehicles));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(LinesMapError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  Future<void> showBusLines() async {
    emit(LinesMapLoading());

    try {
      final busRoutes = await _transitLinesApiService.getBusLines();

      _currentLineType = LineType.bus;
      final busPolylines = _createBusPolylines(busRoutes);

      if (_showVehicles) {
        _startVehicleSimulation(busRoutes, LineType.bus);
      }

      emit(LinesMapLoaded(polylines: busPolylines, selectedType: LineType.bus, showVehicles: _showVehicles));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(LinesMapError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  void toggleVehiclePositions() {
    _showVehicles = !_showVehicles;

    if (_showVehicles) {
      _startVehicleTracking();
    } else {
      _stopVehicleTracking();
    }

    if (_currentLineType == LineType.tram) {
      showTramLines();
    } else if (_currentLineType == LineType.bus) {
      showBusLines();
    }
  }

  void _startVehicleSimulation(Map<String, List<LatLng>> routes, LineType lineType) {
    _vehicleSimulationService.startSimulation(routes, lineType);
  }

  void _startVehicleTracking() {
    _vehicleSubscription = _vehicleSimulationService.vehiclePositionsStream.listen((vehiclePositions) {
      _updateVehicleMarkers(vehiclePositions);
    });
  }

  void _stopVehicleTracking() {
    _vehicleSubscription?.cancel();
    _vehicleSimulationService.stopSimulation();
  }

  Future<void> _updateVehicleMarkers(Map<String, List<VehiclePosition>> vehiclePositions) async {
    final currentState = state;
    if (currentState is! LinesMapLoaded) return;

    final vehicleMarkers = <Marker>[];

    for (final vehicle in vehiclePositions.values.expand((vehicles) => vehicles)) {
      final markerIcon = await vehicle.markerIcon;
      vehicleMarkers.add(
        Marker(
          markerId: MarkerId(vehicle.vehicleId),
          position: vehicle.currentPosition,
          icon: markerIcon,
          infoWindow: InfoWindow(title: vehicle.displayName, snippet: '${vehicle.speed.toStringAsFixed(1)} km/h'),
          rotation: _calculateRotation(vehicle),
        ),
      );
    }

    emit(
      LinesMapLoaded(
        polylines: currentState.polylines,
        selectedType: currentState.selectedType,
        showVehicles: _showVehicles,
        vehicleMarkers: vehicleMarkers,
      ),
    );
  }

  double _calculateRotation(VehiclePosition vehicle) {
    // Calculate bearing between current and next position for realistic rotation
    if (vehicle.currentRouteIndex + 1 < vehicle.routePoints.length) {
      final current = vehicle.currentPosition;
      final next = vehicle.routePoints[vehicle.currentRouteIndex + 1];

      final dLng = next.longitude - current.longitude;
      final dLat = next.latitude - current.latitude;
      return (atan2(dLng, dLat) * 180 / pi);
    }
    return 0.0;
  }

  Future<void> preloadLines() async {
    try {
      await Future.wait([_transitLinesApiService.getTramLines(), _transitLinesApiService.getBusLines()]);
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(LinesMapError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  List<Polyline> _createTramPolylines(Map<String, List<LatLng>> tramRoutes) {
    final polylines = <Polyline>[];

    tramRoutes.forEach((lineNumber, stops) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('tram_line_$lineNumber'),
          points: stops,
          color: Colors.red,
          width: 4,
          patterns: [],
        ),
      );
    });

    return polylines;
  }

  List<Polyline> _createBusPolylines(Map<String, List<LatLng>> busRoutes) {
    final polylines = <Polyline>[];

    busRoutes.forEach((lineNumber, stops) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('bus_line_$lineNumber'),
          points: stops,
          color: Colors.blue,
          width: 4,
          patterns: [],
        ),
      );
    });

    return polylines;
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    _vehicleSimulationService.dispose();
    _mapController?.dispose();
    return super.close();
  }
}

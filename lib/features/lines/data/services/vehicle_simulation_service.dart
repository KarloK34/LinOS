import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/features/lines/data/enums/vehicle_direction.dart';
import 'package:linos/features/lines/data/models/vehicle_position.dart';

@singleton
class VehicleSimulationService {
  final Map<String, List<VehiclePosition>> _activeVehicles = {};
  final Map<String, Timer> _vehicleTimers = {};
  final Random _random = Random();

  Stream<Map<String, List<VehiclePosition>>> get vehiclePositionsStream => _vehicleController.stream;
  final StreamController<Map<String, List<VehiclePosition>>> _vehicleController = StreamController.broadcast();

  void startSimulation(Map<String, List<LatLng>> routes, VehicleType lineType) {
    stopSimulation();

    routes.forEach((lineId, routePoints) {
      if (routePoints.length > 1) {
        _createVehiclesForLine(lineId, routePoints, lineType);
      }
    });

    _broadcastPositions();
  }

  void _createVehiclesForLine(String lineId, List<LatLng> routePoints, VehicleType lineType) {
    final vehicleCount = _getVehicleCountForLine(lineId, lineType);
    final vehicles = <VehiclePosition>[];

    for (int i = 0; i < vehicleCount; i++) {
      final progressPercentage = (i / vehicleCount);
      final routeIndex = (progressPercentage * (routePoints.length - 1)).floor();

      final vehicle = VehiclePosition(
        vehicleId: '${lineId}_vehicle_$i',
        lineId: lineId,
        currentPosition: routePoints[routeIndex],
        routePoints: routePoints,
        currentRouteIndex: routeIndex,
        direction: _random.nextBool() ? VehicleDirection.forward : VehicleDirection.backward,
        speed: _getRandomSpeed(lineType),
        lineType: lineType,
        lastUpdate: DateTime.now(),
      );

      vehicles.add(vehicle);
    }

    _activeVehicles[lineId] = vehicles;

    _vehicleTimers[lineId] = Timer.periodic(const Duration(seconds: 10), (_) => _updateVehiclesForLine(lineId));
  }

  void _updateVehiclesForLine(String lineId) {
    final vehicles = _activeVehicles[lineId];
    if (vehicles == null) return;

    for (final vehicle in vehicles) {
      _moveVehicle(vehicle);
    }

    _broadcastPositions();
  }

  void _moveVehicle(VehiclePosition vehicle) {
    final routePoints = vehicle.routePoints;
    int newIndex = vehicle.currentRouteIndex;

    if (vehicle.direction == VehicleDirection.forward) {
      newIndex++;
      if (newIndex >= routePoints.length) {
        newIndex = routePoints.length - 2;
        vehicle.direction = VehicleDirection.backward;
      }
    } else {
      newIndex--;
      if (newIndex < 0) {
        newIndex = 1;
        vehicle.direction = VehicleDirection.forward;
      }
    }

    vehicle.currentRouteIndex = newIndex;
    vehicle.currentPosition = routePoints[newIndex];
    vehicle.lastUpdate = DateTime.now();

    if (_random.nextInt(10) == 0) {
      vehicle.speed = _getRandomSpeed(vehicle.lineType);
    }
  }

  int _getVehicleCountForLine(String lineId, VehicleType lineType) {
    switch (lineType) {
      case VehicleType.tram:
        return _random.nextInt(3) + 2;
      case VehicleType.bus:
        return _random.nextInt(4) + 3;
    }
  }

  double _getRandomSpeed(VehicleType lineType) {
    switch (lineType) {
      case VehicleType.tram:
        return 15.0 + _random.nextDouble() * 10;
      case VehicleType.bus:
        return 20.0 + _random.nextDouble() * 15;
    }
  }

  void _broadcastPositions() {
    _vehicleController.add(Map.from(_activeVehicles));
  }

  void stopSimulation() {
    for (var timer in _vehicleTimers.values) {
      timer.cancel();
    }
    _vehicleTimers.clear();
    _activeVehicles.clear();
  }

  void dispose() {
    stopSimulation();
    _vehicleController.close();
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/features/lines/data/enums/vehicle_direction.dart';

class VehiclePosition {
  final String vehicleId;
  final String lineId;
  LatLng currentPosition;
  final List<LatLng> routePoints;
  int currentRouteIndex;
  VehicleDirection direction;
  double speed;
  final VehicleType lineType;
  DateTime lastUpdate;

  VehiclePosition({
    required this.vehicleId,
    required this.lineId,
    required this.currentPosition,
    required this.routePoints,
    required this.currentRouteIndex,
    required this.direction,
    required this.speed,
    required this.lineType,
    required this.lastUpdate,
  });

  String get displayName {
    switch (lineType) {
      case VehicleType.tram:
        return 'Tramvaj $lineId';
      case VehicleType.bus:
        return 'Autobus $lineId';
    }
  }

  Future<BitmapDescriptor> get markerIcon async {
    switch (lineType) {
      case VehicleType.tram:
        return await BitmapDescriptor.asset(const ImageConfiguration(size: Size(24, 24)), 'assets/png/tram_icon.png');
      case VehicleType.bus:
        return await BitmapDescriptor.asset(const ImageConfiguration(size: Size(24, 24)), 'assets/png/bus_icon.png');
    }
  }

  BitmapDescriptor get fallbackMarkerIcon {
    switch (lineType) {
      case VehicleType.tram:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case VehicleType.bus:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/lines/data/enums/line_type.dart';
import 'package:linos/features/lines/data/enums/vehicle_direction.dart';

class VehiclePosition {
  final String vehicleId;
  final String lineId;
  LatLng currentPosition;
  final List<LatLng> routePoints;
  int currentRouteIndex;
  VehicleDirection direction;
  double speed;
  final LineType lineType;
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
      case LineType.tram:
        return 'Tramvaj $lineId';
      case LineType.bus:
        return 'Autobus $lineId';
    }
  }

  Future<BitmapDescriptor> get markerIcon async {
    switch (lineType) {
      case LineType.tram:
        return await BitmapDescriptor.asset(const ImageConfiguration(size: Size(24, 24)), 'assets/png/tram_icon.png');
      case LineType.bus:
        return await BitmapDescriptor.asset(const ImageConfiguration(size: Size(24, 24)), 'assets/png/bus_icon.png');
    }
  }

  BitmapDescriptor get fallbackMarkerIcon {
    switch (lineType) {
      case LineType.tram:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case LineType.bus:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }
}

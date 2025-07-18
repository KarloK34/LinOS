import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';

abstract class LinesMapState {}

class LinesMapInitial extends LinesMapState {}

class LinesMapLoading extends LinesMapState {}

class LinesMapLoaded extends LinesMapState {
  final List<Polyline> polylines;
  final VehicleType selectedType;
  final bool showVehicles;
  final List<Marker> vehicleMarkers;

  LinesMapLoaded({
    required this.polylines,
    required this.selectedType,
    this.showVehicles = false,
    this.vehicleMarkers = const [],
  });
}

class LinesMapError extends LinesMapState {
  final String errorKey;
  final dynamic originalError;

  LinesMapError(this.errorKey, {this.originalError});
}

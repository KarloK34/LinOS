import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class HomeMapState {
  const HomeMapState();
}

class HomeMapInitial extends HomeMapState {
  const HomeMapInitial();
}

class HomeMapLoadingLocation extends HomeMapState {
  const HomeMapLoadingLocation();
}

class HomeMapLocationLoaded extends HomeMapState {
  final LatLng userLocation;
  final CameraPosition initialCameraPosition;
  final List<Marker> markers;
  final List<Polyline> polylines;

  HomeMapLocationLoaded({
    required this.userLocation,
    required this.initialCameraPosition,
    List<Marker>? markers,
    List<Polyline>? polylines,
  }) : markers = markers ?? [],
       polylines = polylines ?? [];
}

class HomeMapLocationError extends HomeMapState {
  final String message;
  const HomeMapLocationError(this.message);
}

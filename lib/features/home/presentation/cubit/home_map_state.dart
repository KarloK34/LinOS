import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class HomeMapState extends Equatable {
  const HomeMapState();
}

class HomeMapInitial extends HomeMapState {
  const HomeMapInitial();
  @override
  List<Object?> get props => [];
}

class HomeMapLoadingLocation extends HomeMapState {
  const HomeMapLoadingLocation();
  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [userLocation, initialCameraPosition, markers, polylines];
}

class HomeMapLocationError extends HomeMapState {
  final String errorKey;
  final dynamic originalError;

  const HomeMapLocationError(this.errorKey, {this.originalError});

  @override
  List<Object?> get props => [errorKey, originalError];
}

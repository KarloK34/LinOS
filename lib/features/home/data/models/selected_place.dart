import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedPlace extends Equatable {
  final String placeId;
  final String name;
  final LatLng coordinates;

  const SelectedPlace({required this.placeId, required this.name, required this.coordinates});

  @override
  List<Object?> get props => [placeId, name, coordinates];
}

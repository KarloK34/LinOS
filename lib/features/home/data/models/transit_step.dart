import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/home/data/models/transit_details.dart';

class TransitStep {
  final String instructions;
  final Duration duration;
  final String distance;
  final LatLng startLocation;
  final LatLng endLocation;
  final TransitDetails? transitDetails;
  final List<LatLng> polylinePoints;

  const TransitStep({
    required this.instructions,
    required this.duration,
    required this.distance,
    required this.startLocation,
    required this.endLocation,
    required this.polylinePoints,
    this.transitDetails,
  });
}

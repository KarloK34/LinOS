import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/home/data/models/route_segment.dart';
import 'package:linos/features/home/data/models/transit_step.dart';

class TransitRoute {
  final String summary;
  final Duration duration;
  final String distance;
  final List<RouteSegment> segments;
  final List<TransitStep> steps;
  final LatLng startLocation;
  final LatLng endLocation;

  const TransitRoute({
    required this.summary,
    required this.duration,
    required this.distance,
    required this.segments,
    required this.steps,
    required this.startLocation,
    required this.endLocation,
  });
}

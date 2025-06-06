import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/home/data/enums/route_segment_type.dart';

class RouteSegment {
  final List<LatLng> polylinePoints;
  final RouteSegmentType type;
  final String? lineName;
  final String? vehicleType;

  const RouteSegment({required this.polylinePoints, required this.type, this.lineName, this.vehicleType});
}

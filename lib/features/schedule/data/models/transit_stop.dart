import 'package:linos/core/data/enums/vehicle_type.dart';

class TransitStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final VehicleType vehicleType;

  const TransitStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.vehicleType,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'vehicleType': vehicleType.name,
  };

  factory TransitStop.fromJson(Map<String, dynamic> json) => TransitStop(
    id: json['id'],
    name: json['name'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    vehicleType: VehicleType.values.firstWhere(
      (type) => type.name == json['vehicleType'],
      orElse: () => VehicleType.tram,
    ),
  );
}

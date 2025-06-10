import 'package:linos/core/data/enums/vehicle_type.dart';

class TransitStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final VehicleType vehicleType;
  final TransitStopSchedule schedule;
  final String origin;
  final String destination;

  const TransitStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.vehicleType,
    required this.schedule,
    required this.origin,
    required this.destination,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'vehicleType': vehicleType.name,
    'schedule': schedule.toJson(),
    'origin': origin,
    'destination': destination,
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
    schedule: TransitStopSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
    origin: json['origin'] ?? '',
    destination: json['destination'] ?? '',
  );
}

class TransitStopSchedule {
  final List<DateTime> departureTimes;

  TransitStopSchedule({required this.departureTimes});

  Map<String, dynamic> toJson() => {'departureTimes': departureTimes.map((time) => time.toIso8601String()).toList()};

  factory TransitStopSchedule.fromJson(Map<String, dynamic> json) {
    return TransitStopSchedule(
      departureTimes: (json['departureTimes'] as List).map((time) => DateTime.parse(time as String)).toList(),
    );
  }
}

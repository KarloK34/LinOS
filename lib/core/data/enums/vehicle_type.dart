enum VehicleType {
  tram,
  bus;

  Map<String, dynamic> toJson() {
    return {'vehicleType': name};
  }

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType.values.firstWhere((e) => e.name == json['vehicleType'], orElse: () => VehicleType.tram);
  }
}

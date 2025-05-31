class TransitDetails {
  final String lineName;
  final String lineShortName;
  final String vehicleType;
  final int stopCount;
  final String departureStop;
  final String arrivalStop;

  const TransitDetails({
    required this.lineName,
    required this.lineShortName,
    required this.vehicleType,
    required this.stopCount,
    required this.departureStop,
    required this.arrivalStop,
  });
}

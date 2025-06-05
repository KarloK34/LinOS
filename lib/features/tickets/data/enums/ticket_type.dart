import 'package:linos/features/tickets/data/enums/ticket_type_name.dart';

enum TicketType {
  singleRide(TicketTypeName.singleRide, 2.00, Duration(hours: 1)),
  dayPass(TicketTypeName.dayPass, 10.00, Duration(days: 1)),
  weeklyPass(TicketTypeName.weeklyPass, 50.00, Duration(days: 7)),
  monthlyPass(TicketTypeName.monthlyPass, 100.00, Duration(days: 30));

  const TicketType(this.typeName, this.price, this.validity);

  final TicketTypeName typeName;
  final double price;
  final Duration validity;

  Map<String, dynamic> toJson() {
    return {'typeName': typeName.name, 'price': price, 'validity': validity.inSeconds};
  }

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType.values.firstWhere(
      (type) => type.typeName.name == json['typeName'],
      orElse: () => throw ArgumentError('Invalid ticket type: ${json['typeName']}'),
    );
  }
}

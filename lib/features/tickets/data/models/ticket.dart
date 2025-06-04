import 'package:equatable/equatable.dart';
import 'package:linos/features/tickets/data/enums/ticket_status.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';

class Ticket extends Equatable {
  final String id;
  final TicketType type;
  final DateTime purchaseDate;
  final DateTime validFrom;
  final DateTime validUntil;
  final TicketStatus status;
  final String qrCode;
  final double pricePaid;

  const Ticket({
    required this.id,
    required this.type,
    required this.purchaseDate,
    required this.validFrom,
    required this.validUntil,
    required this.status,
    required this.qrCode,
    required this.pricePaid,
  });

  bool get isActive => status == TicketStatus.active && DateTime.now().isBefore(validUntil);
  bool get isExpired => DateTime.now().isAfter(validUntil);

  Ticket copyWith({
    String? id,
    TicketType? type,
    DateTime? purchaseDate,
    DateTime? validFrom,
    DateTime? validUntil,
    TicketStatus? status,
    String? qrCode,
    double? pricePaid,
    String? validationId,
  }) {
    return Ticket(
      id: id ?? this.id,
      type: type ?? this.type,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
      pricePaid: pricePaid ?? this.pricePaid,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'purchaseDate': purchaseDate.toIso8601String(),
    'validFrom': validFrom.toIso8601String(),
    'validUntil': validUntil.toIso8601String(),
    'status': status.name,
    'qrCode': qrCode,
    'pricePaid': pricePaid,
  };

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json['id'],
    type: TicketType.values.byName(json['type']),
    purchaseDate: DateTime.parse(json['purchaseDate']),
    validFrom: DateTime.parse(json['validFrom']),
    validUntil: DateTime.parse(json['validUntil']),
    status: TicketStatus.values.byName(json['status']),
    qrCode: json['qrCode'],
    pricePaid: json['pricePaid'].toDouble(),
  );

  @override
  List<Object?> get props => [id, type, purchaseDate, validFrom, validUntil, status, qrCode, pricePaid];
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:linos/features/tickets/data/enums/ticket_status.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';

class Ticket extends Equatable {
  final String id;
  final String userId;
  final TicketType type;
  final DateTime purchaseDate;
  final DateTime validFrom;
  final DateTime validUntil;
  final TicketStatus status;
  final String qrCode;
  final double pricePaid;
  final DateTime? usedAt;

  const Ticket({
    required this.id,
    required this.userId,
    required this.type,
    required this.purchaseDate,
    required this.validFrom,
    required this.validUntil,
    required this.status,
    required this.qrCode,
    required this.pricePaid,
    this.usedAt,
  });

  bool get isActive => status == TicketStatus.active && DateTime.now().isBefore(validUntil);
  bool get isExpired => DateTime.now().isAfter(validUntil);

  Ticket copyWith({
    String? id,
    String? userId,
    TicketType? type,
    DateTime? purchaseDate,
    DateTime? validFrom,
    DateTime? validUntil,
    TicketStatus? status,
    String? qrCode,
    double? pricePaid,
    String? validationId,
    DateTime? usedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
      pricePaid: pricePaid ?? this.pricePaid,
      usedAt: usedAt ?? this.usedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type.name,
    'purchaseDate': purchaseDate.toIso8601String(),
    'validFrom': validFrom.toIso8601String(),
    'validUntil': validUntil.toIso8601String(),
    'status': status.name,
    'qrCode': qrCode,
    'pricePaid': pricePaid,
    'usedAt': usedAt?.toIso8601String(),
  };

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json['id'],
    userId: json['userId'],
    type: TicketType.values.byName(json['type']),
    purchaseDate: DateTime.parse(json['purchaseDate']),
    validFrom: DateTime.parse(json['validFrom']),
    validUntil: DateTime.parse(json['validUntil']),
    status: TicketStatus.values.byName(json['status']),
    qrCode: json['qrCode'],
    pricePaid: json['pricePaid'].toDouble(),
    usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
  );

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toJson(),
      'pricePaid': pricePaid,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'validFrom': Timestamp.fromDate(validFrom),
      'validUntil': Timestamp.fromDate(validUntil),
      'status': status.name,
      'qrCode': qrCode,
      'usedAt': usedAt != null ? Timestamp.fromDate(usedAt!) : null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: TicketType.fromJson(data['type']),
      pricePaid: (data['pricePaid'] as num).toDouble(),
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validUntil: (data['validUntil'] as Timestamp).toDate(),
      status: TicketStatus.values.byName(data['status']),
      qrCode: data['qrCode'] ?? '',
      usedAt: data['usedAt'] != null ? (data['usedAt'] as Timestamp).toDate() : null,
    );
  }

  @override
  List<Object?> get props => [id, userId, type, purchaseDate, validFrom, validUntil, status, qrCode, pricePaid, usedAt];
}

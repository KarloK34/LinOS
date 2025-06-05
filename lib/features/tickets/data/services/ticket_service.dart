import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:linos/features/tickets/data/enums/ticket_status.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';
import 'package:uuid/uuid.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';

class TicketService {
  static const _uuid = Uuid();

  static String generateTicketId() => _uuid.v4();

  static String generateQRCode(Ticket ticket) {
    final data = {
      'id': ticket.id,
      'type': ticket.type.name,
      'validUntil': ticket.validUntil.toIso8601String(),
      'hash': _generateSecurityHash(ticket),
    };
    return base64Encode(utf8.encode(jsonEncode(data)));
  }

  static String _generateSecurityHash(Ticket ticket) {
    final linosKey = dotenv.env['LINOS_SECRET_KEY'];
    if (linosKey == null) {
      throw Exception('LINOS_SECRET_KEY is not set in .env file');
    }
    final input = '${ticket.id}${ticket.type.name}${ticket.validUntil.millisecondsSinceEpoch}$linosKey';
    return sha256.convert(utf8.encode(input)).toString().substring(0, 16);
  }

  static bool validateTicket(String qrCodeData) {
    try {
      final decoded = jsonDecode(utf8.decode(base64Decode(qrCodeData)));
      final validUntil = DateTime.parse(decoded['validUntil']);

      if (DateTime.now().isAfter(validUntil)) {
        return false;
      }

      // Verify hash (in real app, validate against server)
      final linosKey = dotenv.env['LINOS_SECRET_KEY'];
      if (linosKey == null) {
        throw Exception('LINOS_SECRET_KEY is not set in .env file');
      }
      final expectedHash = sha256
          .convert(utf8.encode('${decoded['id']}${decoded['type']}${validUntil.millisecondsSinceEpoch}$linosKey'))
          .toString()
          .substring(0, 16);

      return decoded['hash'] == expectedHash;
    } catch (e) {
      return false;
    }
  }

  static Ticket createTicket({required TicketType type, DateTime? validFrom}) {
    final now = DateTime.now();
    final from = validFrom ?? now;
    final until = from.add(type.validity);
    final id = generateTicketId();

    final ticket = Ticket(
      id: id,
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      type: type,
      purchaseDate: now,
      validFrom: from,
      validUntil: until,
      status: TicketStatus.active,
      qrCode: '',
      pricePaid: type.price,
      usedAt: null,
    );

    return ticket.copyWith(qrCode: generateQRCode(ticket));
  }
}

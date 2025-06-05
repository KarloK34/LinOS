import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/features/tickets/data/enums/ticket_status.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';
import 'package:linos/features/tickets/data/models/user_balance.dart';
import 'package:linos/features/tickets/data/services/ticket_service.dart';

@lazySingleton
class FirebaseTicketsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseTicketsRepository() : _firestore = FirebaseFirestore.instance, _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Ticket> get _userTicketsRef => _firestore
      .collection('users')
      .doc(_userId)
      .collection('tickets')
      .withConverter<Ticket>(
        fromFirestore: (snapshot, _) => Ticket.fromFirestore(snapshot),
        toFirestore: (ticket, _) => ticket.toFirestore(),
      );

  DocumentReference get _userBalanceRef =>
      _firestore.collection('users').doc(_userId).collection('balance').doc('current');

  Future<void> initializeUser() async {
    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      await userDocRef.set({'email': _auth.currentUser?.email, 'createdAt': FieldValue.serverTimestamp()});
      await _userBalanceRef.set({'amount': 0.0, 'lastUpdated': FieldValue.serverTimestamp()});
    }
  }

  Future<void> ensureUserInitialized() async {
    if (_userId.isNotEmpty) {
      await initializeUser();
    }
  }

  Stream<List<Ticket>> getUserTicketsStream() {
    if (_userId.isEmpty) {
      return Stream.value([]);
    }
    return _userTicketsRef
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Ticket> purchaseTicket(TicketType type) async {
    return await _firestore.runTransaction<Ticket>((transaction) async {
      final balanceDoc = await transaction.get(_userBalanceRef);
      final currentBalance = balanceDoc.exists ? (balanceDoc.data() as Map<String, dynamic>)['amount'] ?? 0.0 : 0.0;

      if (currentBalance < type.price) {
        throw Exception('Insufficient balance');
      }

      final ticket = TicketService.createTicket(type: type);

      final ticketRef = _userTicketsRef.doc(ticket.id);
      transaction.set(ticketRef, ticket);

      transaction.set(_userBalanceRef, {
        'amount': currentBalance - type.price,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      transaction.set(_firestore.collection('purchase_logs').doc(), {
        'userId': _userId,
        'ticketId': ticket.id,
        'ticketType': type.name,
        'amount': type.price,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return ticket;
    });
  }

  Future<void> useTicket(String ticketId) async {
    await _firestore.runTransaction((transaction) async {
      final ticketRef = _userTicketsRef.doc(ticketId);
      final ticketDoc = await transaction.get(ticketRef);

      if (!ticketDoc.exists) {
        throw Exception('Ticket not found');
      }

      final ticket = ticketDoc.data()!;
      if (!ticket.isActive) {
        throw Exception('Ticket is not active or has expired');
      }

      transaction.update(ticketRef, {
        'status': TicketStatus.used.name,
        'usedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(_firestore.collection('ticket_validation_logs').doc(), {
        'ticketId': ticketId,
        'userId': _userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<UserBalance> getUserBalanceStream() {
    return _userBalanceRef.snapshots().map((doc) {
      if (!doc.exists) {
        return UserBalance(currentBalance: 0.0, lastUpdated: DateTime.now());
      }
      final data = doc.data() as Map<String, dynamic>;
      return UserBalance(
        currentBalance: (data['amount'] ?? 0.0).toDouble(),
        lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    });
  }

  Future<void> addBalance(double amount) async {
    await _firestore.runTransaction((transaction) async {
      final balanceDoc = await transaction.get(_userBalanceRef);
      final currentBalance = balanceDoc.exists ? (balanceDoc.data() as Map<String, dynamic>)['amount'] ?? 0.0 : 0.0;

      transaction.set(_userBalanceRef, {
        'amount': currentBalance + amount,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      transaction.set(_firestore.collection('balance_logs').doc(), {
        'userId': _userId,
        'amount': amount,
        'previousBalance': currentBalance,
        'newBalance': currentBalance + amount,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }
}

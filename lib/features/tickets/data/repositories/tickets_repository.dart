import 'package:injectable/injectable.dart';
import 'package:linos/features/tickets/data/enums/ticket_status.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';
import 'package:linos/features/tickets/data/models/user_balance.dart';
import 'package:linos/features/tickets/data/services/ticket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@lazySingleton
class TicketsRepository {
  static const String _ticketsKey = 'user_tickets';
  static const String _balanceKey = 'user_balance';

  Future<List<Ticket>> getUserTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final ticketsJson = prefs.getStringList(_ticketsKey) ?? [];

    return ticketsJson.map((json) => Ticket.fromJson(jsonDecode(json))).toList()
      ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
  }

  Future<void> saveTicket(Ticket ticket) async {
    final tickets = await getUserTickets();
    final existingIndex = tickets.indexWhere((t) => t.id == ticket.id);

    if (existingIndex != -1) {
      tickets[existingIndex] = ticket;
    } else {
      tickets.add(ticket);
    }

    final prefs = await SharedPreferences.getInstance();
    final ticketsJson = tickets.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_ticketsKey, ticketsJson);
  }

  Future<List<Ticket>> getActiveTickets() async {
    final tickets = await getUserTickets();
    return tickets.where((ticket) => ticket.isActive).toList();
  }

  Future<UserBalance> getUserBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final balance = prefs.getDouble(_balanceKey) ?? 0.0;

    return UserBalance(currentBalance: balance, lastUpdated: DateTime.now());
  }

  Future<void> updateBalance(double newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, newBalance);
  }

  Future<Ticket> purchaseTicket(TicketType type) async {
    final ticket = TicketService.createTicket(type: type);

    await saveTicket(ticket);

    final currentBalance = await getUserBalance();
    await updateBalance(currentBalance.currentBalance - type.price);

    return ticket;
  }

  Future<void> useTicket(String ticketId) async {
    final tickets = await getUserTickets();
    final ticket = tickets.firstWhere((t) => t.id == ticketId, orElse: () => throw Exception('Ticket not found'));

    if (!ticket.isActive) {
      throw Exception('Ticket is not active');
    }

    final updatedTicket = ticket.copyWith(status: TicketStatus.used);
    await saveTicket(updatedTicket);
  }

  Future<bool> hasInsufficientBalance(double amount) async {
    final balance = await getUserBalance();
    return balance.currentBalance < amount;
  }

  Future<void> addBalance(double amount) async {
    final currentBalance = await getUserBalance();
    await updateBalance(currentBalance.currentBalance + amount);
  }
}

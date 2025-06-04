import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/features/tickets/data/enums/ticket_status.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';
import 'package:linos/features/tickets/data/repositories/tickets_repository.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final TicketsRepository _ticketsRepository;

  TicketsCubit(this._ticketsRepository) : super(TicketsInitial());

  Future<void> loadUserData() async {
    emit(TicketsLoading());
    try {
      final allTickets = await _ticketsRepository.getUserTickets();
      final activeTickets = await _ticketsRepository.getActiveTickets();
      final userBalance = await _ticketsRepository.getUserBalance();

      emit(TicketsLoaded(allTickets: allTickets, activeTickets: activeTickets, userBalance: userBalance));
    } catch (e) {
      emit(TicketsError('load_user_data_failed|${e.toString()}'));
    }
  }

  Future<void> purchaseTicket(TicketType ticketType) async {
    final currentState = state;
    if (currentState is! TicketsLoaded) return;

    if (await _ticketsRepository.hasInsufficientBalance(ticketType.price)) {
      emit(currentState.copyWith(purchaseStatus: RequestError<bool>('insufficient_balance')));
      return;
    }

    emit(currentState.copyWith(purchaseStatus: const RequestLoading()));

    try {
      await Future.delayed(Duration(seconds: 2));

      await _ticketsRepository.purchaseTicket(ticketType);

      await loadUserData();

      final updatedState = state;
      if (updatedState is TicketsLoaded) {
        emit(updatedState.copyWith(purchaseStatus: const RequestSuccess<bool>(true)));
      }
    } catch (e) {
      emit(currentState.copyWith(purchaseStatus: RequestError<bool>('purchase_ticket_failed|${e.toString()}')));
    }
  }

  Future<void> addBalance(double amount) async {
    final currentState = state;
    if (currentState is! TicketsLoaded) return;

    try {
      await _ticketsRepository.addBalance(amount);

      final updatedBalance = await _ticketsRepository.getUserBalance();
      emit(currentState.copyWith(userBalance: updatedBalance));
    } catch (e) {
      emit(TicketsError('add_balance_failed|${e.toString()}'));
    }
  }

  Future<void> useTicket(String ticketId) async {
    final currentState = state;
    if (currentState is! TicketsLoaded) return;

    try {
      final updatedTickets = currentState.allTickets.map((ticket) {
        if (ticket.id == ticketId && ticket.isActive) {
          _ticketsRepository.useTicket(ticketId);
          return ticket.copyWith(status: TicketStatus.used);
        }
        return ticket;
      }).toList();

      emit(currentState.copyWith(allTickets: updatedTickets));
    } catch (e) {
      emit(TicketsError('use_ticket_failed|${e.toString()}'));
    }
  }

  void clearPurchaseStatus() {
    final currentState = state;
    if (currentState is TicketsLoaded) {
      emit(currentState.copyWith(purchaseStatus: const RequestInitial()));
    }
  }

  Future<void> refreshTickets() async {
    await loadUserData();
  }
}

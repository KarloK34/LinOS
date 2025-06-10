import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';
import 'package:linos/features/tickets/data/models/user_balance.dart';
import 'package:linos/features/tickets/data/repositories/firebase_tickets_repository.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final FirebaseTicketsRepository _ticketsRepository;
  StreamSubscription<List<Ticket>>? _ticketsSubscription;
  StreamSubscription<UserBalance>? _balanceSubscription;

  TicketsCubit(this._ticketsRepository) : super(TicketsInitial()) {
    _initializeUserAndStartListening();
  }

  @override
  Future<void> close() {
    _ticketsSubscription?.cancel();
    _balanceSubscription?.cancel();
    return super.close();
  }

  Future<void> _initializeUserAndStartListening() async {
    emit(TicketsLoading());

    try {
      await _ticketsRepository.ensureUserInitialized();
      _startListening();
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(TicketsError(errorKey, originalError: e));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  void _startListening() {
    emit(TicketsLoading());

    _startTicketsListener();
    _startBalanceListener();
  }

  void _startTicketsListener() {
    _ticketsSubscription = _ticketsRepository.getUserTicketsStream().listen(
      (allTickets) {
        final activeTickets = allTickets.where((t) => t.isActive).toList();
        _updateTicketsState(allTickets, activeTickets);
      },
      onError: (error) {
        final errorKey = AppErrorHandler.getErrorKey(error);
        emit(TicketsError(errorKey, originalError: error));
        AppErrorLogger.handleError(error, StackTrace.current);
      },
    );
  }

  void _startBalanceListener() {
    _balanceSubscription = _ticketsRepository.getUserBalanceStream().listen(
      (balance) {
        _updateBalanceState(balance);
      },
      onError: (error) {
        final errorKey = AppErrorHandler.getErrorKey(error);
        emit(TicketsError(errorKey, originalError: error));
        AppErrorLogger.handleError(error, StackTrace.current);
      },
    );
  }

  void _updateTicketsState(List<Ticket> allTickets, List<Ticket> activeTickets) {
    final currentState = state;

    if (currentState is TicketsLoaded) {
      emit(currentState.copyWith(allTickets: allTickets, activeTickets: activeTickets));
    } else {
      emit(
        TicketsLoaded(
          allTickets: allTickets,
          activeTickets: activeTickets,
          userBalance: UserBalance.empty(),
          purchaseStatus: const RequestInitial(),
          useTicketStatus: const RequestInitial(),
        ),
      );
    }
  }

  void _updateBalanceState(UserBalance balance) {
    final currentState = state;

    if (currentState is TicketsLoaded) {
      emit(currentState.copyWith(userBalance: balance));
    } else {
      emit(
        TicketsLoaded(
          allTickets: [],
          activeTickets: [],
          userBalance: balance,
          purchaseStatus: const RequestInitial(),
          useTicketStatus: const RequestInitial(),
        ),
      );
    }
  }

  Future<void> purchaseTicket(TicketType ticketType) async {
    final currentState = state;
    if (currentState is! TicketsLoaded) return;

    emit(currentState.copyWith(purchaseStatus: const RequestLoading()));

    try {
      await _ticketsRepository.purchaseTicket(ticketType);
      emit(currentState.copyWith(purchaseStatus: const RequestSuccess<bool>(true)));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(currentState.copyWith(purchaseStatus: RequestError<bool>(errorKey, originalError: e)));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> addBalance(double amount) async {
    try {
      await _ticketsRepository.addBalance(amount);
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      final currentState = state;
      if (currentState is TicketsLoaded) {
        emit(currentState.copyWith(purchaseStatus: RequestError<bool>(errorKey, originalError: e)));
      } else {
        emit(TicketsError(errorKey));
      }
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> useTicket(String ticketId) async {
    final currentState = state;
    if (currentState is! TicketsLoaded) return;

    emit(currentState.copyWith(useTicketStatus: const RequestLoading()));

    try {
      await _ticketsRepository.useTicket(ticketId);
      emit(currentState.copyWith(useTicketStatus: const RequestSuccess<bool>(true)));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(currentState.copyWith(useTicketStatus: RequestError<bool>(errorKey, originalError: e)));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  List<Ticket> getTicketsHistory() {
    _ensureTicketsLoaded();
    final currentState = state;
    if (currentState is! TicketsLoaded) return [];

    final allTickets = currentState.allTickets;

    if (allTickets.isEmpty) return [];

    final sortedTickets = allTickets..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

    return sortedTickets;
  }

  void _ensureTicketsLoaded() {
    if (state is TicketsInitial || state is TicketsLoading) {
      _startListening();
    }
  }

  void clearPurchaseStatus() {
    final currentState = state;
    if (currentState is TicketsLoaded) {
      emit(currentState.copyWith(purchaseStatus: const RequestInitial()));
    }
  }
}

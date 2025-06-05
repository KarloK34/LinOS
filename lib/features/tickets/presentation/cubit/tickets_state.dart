import 'package:equatable/equatable.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';
import 'package:linos/features/tickets/data/models/user_balance.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object?> get props => [];
}

class TicketsInitial extends TicketsState {}

class TicketsLoading extends TicketsState {}

class TicketsLoaded extends TicketsState {
  final List<Ticket> allTickets;
  final List<Ticket> activeTickets;
  final UserBalance userBalance;
  final RequestState<bool> purchaseStatus;
  final RequestState<bool> useTicketStatus;

  const TicketsLoaded({
    required this.allTickets,
    required this.activeTickets,
    required this.userBalance,
    this.purchaseStatus = const RequestInitial(),
    this.useTicketStatus = const RequestInitial(),
  });

  TicketsLoaded copyWith({
    List<Ticket>? allTickets,
    List<Ticket>? activeTickets,
    UserBalance? userBalance,
    RequestState<bool>? purchaseStatus,
    RequestState<bool>? useTicketStatus,
  }) {
    return TicketsLoaded(
      allTickets: allTickets ?? this.allTickets,
      activeTickets: activeTickets ?? this.activeTickets,
      userBalance: userBalance ?? this.userBalance,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      useTicketStatus: useTicketStatus ?? this.useTicketStatus,
    );
  }

  @override
  List<Object?> get props => [allTickets, activeTickets, userBalance, purchaseStatus, useTicketStatus];
}

class TicketsError extends TicketsState {
  final String errorKey;
  final dynamic originalError;

  const TicketsError(this.errorKey, {this.originalError});

  @override
  List<Object?> get props => [errorKey, originalError];
}

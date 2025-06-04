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

  const TicketsLoaded({
    required this.allTickets,
    required this.activeTickets,
    required this.userBalance,
    this.purchaseStatus = const RequestInitial(),
  });

  TicketsLoaded copyWith({
    List<Ticket>? allTickets,
    List<Ticket>? activeTickets,
    UserBalance? userBalance,
    RequestState<bool>? purchaseStatus,
  }) {
    return TicketsLoaded(
      allTickets: allTickets ?? this.allTickets,
      activeTickets: activeTickets ?? this.activeTickets,
      userBalance: userBalance ?? this.userBalance,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
    );
  }

  @override
  List<Object?> get props => [allTickets, activeTickets, userBalance, purchaseStatus];
}

class TicketsError extends TicketsState {
  final String message;

  const TicketsError(this.message);

  @override
  List<Object> get props => [message];
}

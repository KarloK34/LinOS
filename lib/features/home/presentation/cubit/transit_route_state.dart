import 'package:equatable/equatable.dart';
import 'package:linos/features/home/data/models/transit_route.dart';

abstract class TransitRouteState extends Equatable {
  const TransitRouteState();

  @override
  List<Object?> get props => [];
}

class TransitRouteInitial extends TransitRouteState {}

class TransitRouteLoading extends TransitRouteState {}

class TransitRouteLoaded extends TransitRouteState {
  final TransitRoute route;
  final List<TransitRoute> alternativeRoutes;

  const TransitRouteLoaded({required this.route, this.alternativeRoutes = const []});

  @override
  List<Object?> get props => [route, alternativeRoutes];
}

class TransitRouteError extends TransitRouteState {
  final String message;

  const TransitRouteError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TransitRouteCleared extends TransitRouteState {}

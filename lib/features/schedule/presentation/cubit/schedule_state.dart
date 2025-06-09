import 'package:equatable/equatable.dart';
import 'package:linos/features/schedule/data/models/transit_stop.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<TransitStop> favoriteTramStops;
  final List<TransitStop> favoriteBusStops;
  final List<TransitStop> tramStops;
  final List<TransitStop> busStops;
  final TransitStop? selectedStop;

  const ScheduleLoaded({
    required this.favoriteTramStops,
    required this.favoriteBusStops,
    this.selectedStop,
    required this.tramStops,
    required this.busStops,
  });

  @override
  List<Object?> get props => [favoriteTramStops, favoriteBusStops, selectedStop, tramStops, busStops];

  ScheduleLoaded copyWith({
    List<TransitStop>? favoriteTramStops,
    List<TransitStop>? favoriteBusStops,
    TransitStop? selectedStop,
    List<TransitStop>? tramStops,
    List<TransitStop>? busStops,
  }) {
    return ScheduleLoaded(
      favoriteTramStops: favoriteTramStops ?? this.favoriteTramStops,
      favoriteBusStops: favoriteBusStops ?? this.favoriteBusStops,
      selectedStop: selectedStop,
      tramStops: tramStops ?? this.tramStops,
      busStops: busStops ?? this.busStops,
    );
  }
}

class ScheduleError extends ScheduleState {
  final String errorKey;
  final dynamic originalError;

  const ScheduleError(this.errorKey, {this.originalError});

  @override
  List<Object> get props => [errorKey, originalError];
}

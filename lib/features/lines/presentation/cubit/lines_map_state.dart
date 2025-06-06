import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/lines/data/enums/line_type.dart';

abstract class LinesMapState extends Equatable {}

class LinesMapInitial extends LinesMapState {
  @override
  List<Object?> get props => [];
}

class LinesMapLoading extends LinesMapState {
  @override
  List<Object?> get props => [];
}

class LinesMapLoaded extends LinesMapState {
  final List<Polyline> polylines;
  final LineType selectedType;

  LinesMapLoaded({required this.polylines, required this.selectedType});

  @override
  List<Object?> get props => [polylines, selectedType];
}

class LinesMapError extends LinesMapState {
  final String errorKey;
  final dynamic originalError;

  LinesMapError(this.errorKey, {this.originalError});

  @override
  List<Object?> get props => [errorKey, originalError];
}

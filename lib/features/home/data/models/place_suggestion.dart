import 'package:equatable/equatable.dart';

class PlaceSuggestion extends Equatable {
  final String description;
  final String placeId;

  const PlaceSuggestion({required this.description, required this.placeId});

  @override
  List<Object?> get props => [description, placeId];
}

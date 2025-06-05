import 'package:equatable/equatable.dart';
import 'package:linos/features/home/data/models/place_suggestion.dart';
import 'package:linos/features/home/data/models/selected_place.dart';

abstract class SearchDestinationState extends Equatable {
  const SearchDestinationState();

  @override
  List<Object?> get props => [];
}

class SearchDestinationInitial extends SearchDestinationState {}

class SearchDestinationLoading extends SearchDestinationState {}

class SearchDestinationSuggestionsLoaded extends SearchDestinationState {
  final List<PlaceSuggestion> suggestions;

  const SearchDestinationSuggestionsLoaded({required this.suggestions});

  @override
  List<Object?> get props => [suggestions];
}

class SearchDestinationSelected extends SearchDestinationState {
  final SelectedPlace selectedPlace;

  const SearchDestinationSelected({required this.selectedPlace});

  @override
  List<Object?> get props => [selectedPlace];
}

class SearchDestinationError extends SearchDestinationState {
  final String errorKey;
  final dynamic originalError;

  const SearchDestinationError({required this.errorKey, this.originalError});

  @override
  List<Object?> get props => [errorKey, originalError];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/features/home/data/models/place_suggestion.dart';
import 'package:linos/features/home/data/models/selected_place.dart';
import 'package:linos/features/home/data/services/google_places_api_service.dart';
import 'search_destination_state.dart';

class SearchDestinationCubit extends Cubit<SearchDestinationState> {
  final GooglePlacesApiService _placesApiService;

  SearchDestinationCubit(this._placesApiService) : super(SearchDestinationInitial());

  Future<List<PlaceSuggestion>> searchPlaces(String query, String sessionToken) async {
    if (query.isEmpty) {
      emit(SearchDestinationInitial());
      return [];
    }
    emit(SearchDestinationLoading());
    try {
      final suggestions = await _placesApiService.getPlaceAutocomplete(query, sessionToken: sessionToken);
      emit(SearchDestinationSuggestionsLoaded(suggestions: suggestions));
      return suggestions;
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(SearchDestinationError(errorKey: errorKey, originalError: e));
      AppErrorLogger.handleError(e, stackTrace);
      return [];
    }
  }

  Future<void> selectPlace(PlaceSuggestion suggestion, String sessionToken) async {
    emit(SearchDestinationLoading());
    try {
      final placeDetails = await _placesApiService.getPlaceDetails(suggestion.placeId, sessionToken: sessionToken);
      final selectedPlace = SelectedPlace(
        placeId: suggestion.placeId,
        name: suggestion.description,
        coordinates: LatLng(
          placeDetails['geometry']['location']['lat'] as double,
          placeDetails['geometry']['location']['lng'] as double,
        ),
      );
      emit(SearchDestinationSelected(selectedPlace: selectedPlace));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(SearchDestinationError(errorKey: errorKey, originalError: e));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  Future<void> selectPopularDestination(SelectedPlace selectedPlace) async {
    emit(SearchDestinationLoading());
    try {
      emit(SearchDestinationSelected(selectedPlace: selectedPlace));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(SearchDestinationError(errorKey: errorKey, originalError: e));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }

  void clearSearch() {
    emit(SearchDestinationInitial());
  }
}

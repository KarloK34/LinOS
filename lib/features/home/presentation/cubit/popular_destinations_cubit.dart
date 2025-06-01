import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/features/home/data/models/search_history_item.dart';
import 'package:linos/features/home/data/models/selected_place.dart';
import 'package:linos/features/home/data/repositories/search_history_repository.dart';

class PopularDestinationsCubit extends Cubit<List<SearchHistoryItem>> {
  final SearchHistoryRepository _repository;

  PopularDestinationsCubit(this._repository) : super([]);

  Future<void> loadPopularDestinations() async {
    try {
      final destinations = await _repository.getPopularDestinations();
      emit(destinations);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> addSearchToHistory(SelectedPlace place) async {
    try {
      await _repository.addSearchItem(place);
      await loadPopularDestinations();
    } catch (e) {
      // Handle error
    }
  }
}

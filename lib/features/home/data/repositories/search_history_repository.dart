import 'package:injectable/injectable.dart';
import 'package:linos/features/home/data/models/search_history_item.dart';
import 'package:linos/features/home/data/models/selected_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@singleton
class SearchHistoryRepository {
  static const String _searchHistoryKey = 'search_history';

  Future<List<SearchHistoryItem>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_searchHistoryKey) ?? [];

    return historyJson.map((json) => SearchHistoryItem.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addSearchItem(SelectedPlace place) async {
    final history = await getSearchHistory();

    final existingIndex = history.indexWhere((item) => item.placeName == place.name);

    if (existingIndex != -1) {
      history[existingIndex] = history[existingIndex].copyWith(
        searchCount: history[existingIndex].searchCount + 1,
        lastSearched: DateTime.now(),
      );
    } else {
      history.add(
        SearchHistoryItem(
          placeId: place.placeId,
          placeName: place.name,
          latitude: place.coordinates.latitude,
          longitude: place.coordinates.longitude,
          searchCount: 1,
          lastSearched: DateTime.now(),
        ),
      );
    }

    history.sort((a, b) => b.searchCount.compareTo(a.searchCount));
    final topHistory = history.take(10).toList();

    final prefs = await SharedPreferences.getInstance();
    final historyJson = topHistory.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList(_searchHistoryKey, historyJson);
  }

  Future<List<SearchHistoryItem>> getPopularDestinations() async {
    final history = await getSearchHistory();
    return history.take(5).toList();
  }
}

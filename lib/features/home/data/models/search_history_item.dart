class SearchHistoryItem {
  final String placeId;
  final String placeName;
  final double latitude;
  final double longitude;
  final int searchCount;
  final DateTime lastSearched;

  SearchHistoryItem({
    required this.placeId,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.searchCount,
    required this.lastSearched,
  });

  SearchHistoryItem copyWith({
    String? placeId,
    String? placeName,
    double? latitude,
    double? longitude,
    int? searchCount,
    DateTime? lastSearched,
  }) {
    return SearchHistoryItem(
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      searchCount: searchCount ?? this.searchCount,
      lastSearched: lastSearched ?? this.lastSearched,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'placeName': placeName,
      'latitude': latitude,
      'longitude': longitude,
      'searchCount': searchCount,
      'lastSearched': lastSearched.toIso8601String(),
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      placeId: json['placeId'],
      placeName: json['placeName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      searchCount: json['searchCount'],
      lastSearched: DateTime.parse(json['lastSearched']),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:linos/features/home/data/models/place_suggestion.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@singleton
class GooglePlacesApiService {
  final String? _apiKey = dotenv.env['MAPS_API_KEY'];
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<PlaceSuggestion>> getPlaceAutocomplete(String input, {String? sessionToken}) async {
    const osijekLat = 45.55111;
    const osijekLng = 18.69389;
    const radius = 20000; // 20km

    final Uri url = Uri.parse('$_baseUrl/autocomplete/json').replace(
      queryParameters: {
        'input': input,
        'key': _apiKey,
        'sessiontoken': sessionToken ?? '',
        'location': '$osijekLat,$osijekLng',
        'radius': radius.toString(),
        'components': 'country:hr',
        'types': 'establishment|geocode',
        'language': 'hr',
      },
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final List<dynamic> predictions = data['predictions'] ?? [];
          return predictions
              .map(
                (prediction) =>
                    PlaceSuggestion(description: prediction['description'], placeId: prediction['place_id']),
              )
              .toList();
        } else {
          throw Exception('Places API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch place suggestions: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId, {String? sessionToken}) async {
    final Uri url = Uri.parse('$_baseUrl/details/json').replace(
      queryParameters: {
        'place_id': placeId,
        'key': _apiKey,
        'sessiontoken': sessionToken ?? '',
        'fields': 'place_id,name,geometry,formatted_address,types',
        'language': 'hr',
      },
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result'] as Map<String, dynamic>;
        } else {
          throw Exception('Failed to fetch place details: ${data['error_message'] ?? data['status']}');
        }
      } else {
        throw Exception('Failed to fetch place details: HTTP ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

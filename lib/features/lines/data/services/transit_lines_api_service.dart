import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/features/lines/data/services/transit_lines_cache_service.dart';

@singleton
class TransitLinesApiService {
  final String? _apiKey = dotenv.env['MAPS_API_KEY'];
  final String _directionsBaseUrl = 'https://maps.googleapis.com/maps/api/directions';

  Future<Map<String, List<LatLng>>> getTramLines() async {
    final Map<String, List<LatLng>>? cachedTramLines = await getIt<TransitLinesCacheService>().getCachedTramLines();

    if (cachedTramLines != null) {
      return cachedTramLines;
    }

    if (_apiKey == null) {
      throw Exception('MAPS_API_KEY not found in environment variables');
    }

    final tramLines = <String, List<LatLng>>{};
    final foundRoutes = await _fetchAnyTransitRoutes('tram');

    for (int i = 0; i < foundRoutes.length; i++) {
      tramLines["${(i + 1)}"] = foundRoutes[i];
    }

    await getIt<TransitLinesCacheService>().cacheTramLines(tramLines);

    return tramLines;
  }

  Future<Map<String, List<LatLng>>> getBusLines() async {
    final Map<String, List<LatLng>>? cachedBusLines = await getIt<TransitLinesCacheService>().getCachedBusLines();

    if (cachedBusLines != null) {
      return cachedBusLines;
    }

    if (_apiKey == null) {
      throw Exception('MAPS_API_KEY not found in environment variables');
    }

    final busLines = <String, List<LatLng>>{};
    final foundRoutes = await _fetchAnyTransitRoutes('bus');

    for (int i = 0; i < foundRoutes.length; i++) {
      busLines["$i"] = foundRoutes[i];
    }

    await getIt<TransitLinesCacheService>().cacheBusLines(busLines);

    return busLines;
  }

  Future<List<List<LatLng>>> _fetchAnyTransitRoutes(String vehicleType) async {
    final foundRoutes = <List<LatLng>>[];
    final processedRoutes = <String>{};

    final osijekLocations = [
      {'name': 'Centar', 'lat': 45.55111, 'lng': 18.69389},
      {'name': 'Tvrđa', 'lat': 45.5615, 'lng': 18.6773},
      {'name': 'Zeleno Polje', 'lat': 45.5525, 'lng': 18.7298},
      {'name': 'Novi Grad', 'lat': 45.5489, 'lng': 18.7156},
      {'name': 'Retfala', 'lat': 45.5334, 'lng': 18.7445},
      {'name': 'Sjenjak', 'lat': 45.5621, 'lng': 18.7089},
      {'name': 'Gornji Grad', 'lat': 45.5445, 'lng': 18.7234},
      {'name': 'Industrijsko', 'lat': 45.5778, 'lng': 18.6912},
    ];

    for (int i = 0; i < osijekLocations.length; i++) {
      for (int j = 0; j < osijekLocations.length; j++) {
        if (i != j) {
          final origin = '${osijekLocations[i]['lat']},${osijekLocations[i]['lng']}';
          final destination = '${osijekLocations[j]['lat']},${osijekLocations[j]['lng']}';

          final routes = await _fetchRoutesFromQuery(origin, destination, vehicleType);

          for (final route in routes) {
            final routeKey = route
                .map((p) => '${p.latitude.toStringAsFixed(4)},${p.longitude.toStringAsFixed(4)}')
                .join('|');

            if (!processedRoutes.contains(routeKey) && route.length > 2) {
              foundRoutes.add(route);
              processedRoutes.add(routeKey);
            }
          }

          if (foundRoutes.length >= 10) break;
        }
      }
      if (foundRoutes.length >= 10) break;
    }

    return foundRoutes;
  }

  Future<List<List<LatLng>>> _fetchRoutesFromQuery(String origin, String destination, String vehicleType) async {
    final foundRoutes = <List<LatLng>>[];

    final departureTimes = [
      DateTime.now().add(const Duration(minutes: 5)),
      DateTime.now().add(const Duration(hours: 1)),
      DateTime.now().add(const Duration(hours: 2)),
      DateTime.now().add(const Duration(hours: 4)),
    ];

    for (final departureTime in departureTimes) {
      final Uri url = Uri.parse('$_directionsBaseUrl/json').replace(
        queryParameters: {
          'origin': origin,
          'destination': destination,
          'mode': 'transit',
          'transit_mode': vehicleType,
          'departure_time': (departureTime.millisecondsSinceEpoch ~/ 1000).toString(),
          'key': _apiKey!,
          'language': 'hr',
          'region': 'hr',
          'alternatives': 'true',
        },
      );

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data['status'] == 'OK') {
            final routes = data['routes'] as List;

            for (final route in routes) {
              final legs = route['legs'] as List;
              for (final leg in legs) {
                final steps = leg['steps'] as List;

                for (final step in steps) {
                  if (step['travel_mode'] == 'TRANSIT' && step['transit_details'] != null) {
                    final transitDetails = step['transit_details'];
                    final apiVehicleType = transitDetails['line']?['vehicle']?['type']?.toString().toLowerCase() ?? '';

                    bool isCorrectVehicleType = false;
                    if (vehicleType == 'bus' && apiVehicleType == 'bus') {
                      isCorrectVehicleType = true;
                    } else if (vehicleType == 'tram' &&
                        (apiVehicleType == 'tram' || apiVehicleType == 'light_rail' || apiVehicleType == 'rail')) {
                      isCorrectVehicleType = true;
                    }

                    if (isCorrectVehicleType) {
                      final polyline = _extractPolylineFromStep(step);
                      if (polyline.isNotEmpty) {
                        foundRoutes.add(polyline);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      } catch (e, stackTrace) {
        AppErrorLogger.handleError(e, stackTrace);
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }

    return foundRoutes;
  }

  List<LatLng> _extractPolylineFromStep(Map<String, dynamic> step) {
    final polylinePoints = <LatLng>[];

    if (step['polyline'] != null && step['polyline']['points'] != null) {
      final decodedPoints = decodePolyline(step['polyline']['points']);
      polylinePoints.addAll(decodedPoints.map((point) => LatLng(point[0].toDouble(), point[1].toDouble())));
    }

    return polylinePoints;
  }
}

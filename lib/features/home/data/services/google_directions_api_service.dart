import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/features/home/data/enums/route_segment_type.dart';
import 'package:linos/features/home/data/models/route_segment.dart';
import 'package:linos/features/home/data/models/transit_details.dart';
import 'package:linos/features/home/data/models/transit_route.dart';
import 'package:linos/features/home/data/models/transit_step.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

@singleton
class GoogleDirectionsApiService {
  final String? _apiKey = dotenv.env['MAPS_API_KEY'];
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/directions';
  late final Dio _dio;

  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  GoogleDirectionsApiService() {
    _dio = Dio(BaseOptions(connectTimeout: _timeout, receiveTimeout: _timeout, sendTimeout: _timeout));
  }

  Future<bool> _hasNetworkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return true;
    }
  }

  Future<List<TransitRoute>> getTransitDirections({
    required LatLng origin,
    required LatLng destination,
    DateTime? departureTime,
  }) async {
    if (_apiKey == null) {
      throw Exception('MAPS_API_KEY not found in environment variables');
    }
    if (!(await _hasNetworkConnection())) {
      throw 'error_network_error';
    }

    final departure = departureTime ?? DateTime.now().add(const Duration(minutes: 5));

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await _dio.get(
          '$_baseUrl/json',
          queryParameters: {
            'origin': '${origin.latitude},${origin.longitude}',
            'destination': '${destination.latitude},${destination.longitude}',
            'mode': 'transit',
            'departure_time': (departure.millisecondsSinceEpoch ~/ 1000).toString(),
            'key': _apiKey,
            'language': 'hr',
            'region': 'hr',
            'alternatives': 'true',
            'transit_mode': 'bus|tram|rail',
            'transit_routing_preference': 'fewer_transfers',
            'units': 'metric',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = response.data;

          if (data['status'] == 'OK') {
            final List<dynamic> routes = data['routes'] ?? [];
            return routes.map((route) => _parseTransitRoute(route)).toList();
          } else {
            final status = data['status'];
            switch (status) {
              case 'ZERO_RESULTS':
                throw 'error_no_routes_found';
              case 'OVER_QUERY_LIMIT':
                if (attempt == _maxRetries) {
                  throw 'error_rate_limit_exceeded';
                }
                await Future.delayed(_retryDelay * attempt * 2);
                continue;
              case 'REQUEST_DENIED':
                throw 'error_api_key_error';
              default:
                throw 'error_api_error';
            }
          }
        } else {
          if (attempt == _maxRetries) {
            throw 'error_connection_abort';
          }
          await Future.delayed(_retryDelay * attempt);
          continue;
        }
      } on SocketException catch (_) {
        if (attempt == _maxRetries) {
          throw 'error_network_error';
        }
        await Future.delayed(_retryDelay * attempt);
      } on DioException catch (e) {
        if (attempt == _maxRetries) {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              throw 'error_connection_abort';
            case DioExceptionType.connectionError:
              throw 'error_network_error';
            default:
              throw 'error_connection_abort';
          }
        }
        final delayMultiplier = e.type == DioExceptionType.connectionError ? 3 : 1;
        await Future.delayed(_retryDelay * attempt * delayMultiplier);
      } on TimeoutException catch (_) {
        if (attempt == _maxRetries) {
          throw 'error_connection_abort';
        }
        await Future.delayed(_retryDelay * attempt);
      } on FormatException catch (_) {
        if (attempt == _maxRetries) {
          throw 'error_api_error';
        }
        await Future.delayed(_retryDelay * attempt);
      } catch (e) {
        if (attempt == _maxRetries) {
          throw 'Failed to fetch transit directions: $e';
        }
        await Future.delayed(_retryDelay * attempt);
      }
    }

    throw 'error_connection_abort';
  }

  TransitRoute _parseTransitRoute(Map<String, dynamic> route) {
    final leg = route['legs'][0];
    final duration = Duration(seconds: leg['duration']['value']);
    final distance = leg['distance']['text'];
    final summary = route['summary'] ?? 'Transit Route';

    final steps = (leg['steps'] as List).map((step) => _parseTransitStep(step)).toList();

    final segments = _createRouteSegments(steps);

    return TransitRoute(
      summary: summary,
      duration: duration,
      distance: distance,
      segments: segments,
      steps: steps,
      startLocation: LatLng(leg['start_location']['lat'].toDouble(), leg['start_location']['lng'].toDouble()),
      endLocation: LatLng(leg['end_location']['lat'].toDouble(), leg['end_location']['lng'].toDouble()),
    );
  }

  TransitStep _parseTransitStep(Map<String, dynamic> step) {
    final duration = Duration(seconds: step['duration']['value']);
    final distance = step['distance']['text'];
    final instructions = step['html_instructions'].replaceAll(RegExp(r'<[^>]*>'), '');

    List<LatLng> stepPolylinePoints = [];
    if (step['polyline'] != null && step['polyline']['points'] != null) {
      stepPolylinePoints = decodePolyline(
        step['polyline']['points'],
      ).map((point) => LatLng(point[0].toDouble(), point[1].toDouble())).toList();
    }

    if (step['travel_mode'] == 'TRANSIT' && step['transit_details'] != null) {
      final transitDetails = step['transit_details'];
      final lineNumber = transitDetails['line']?['short_name']?.toString() ?? '';

      if (lineNumber.isNotEmpty &&
          transitDetails['departure_stop']?['location'] != null &&
          transitDetails['arrival_stop']?['location'] != null) {
        final departureStop = LatLng(
          transitDetails['departure_stop']['location']['lat'].toDouble(),
          transitDetails['departure_stop']['location']['lng'].toDouble(),
        );
        final arrivalStop = LatLng(
          transitDetails['arrival_stop']['location']['lat'].toDouble(),
          transitDetails['arrival_stop']['location']['lng'].toDouble(),
        );

        stepPolylinePoints = _optimizeOsijekTramRoute(stepPolylinePoints, lineNumber, departureStop, arrivalStop);
      }
    }

    TransitDetails? transitDetails;
    if (step['travel_mode'] == 'TRANSIT' && step['transit_details'] != null) {
      final transit = step['transit_details'];
      transitDetails = TransitDetails(
        lineName: transit['line']['name'] ?? 'Unknown Line',
        lineShortName: transit['line']['short_name'] ?? '',
        vehicleType: transit['line']['vehicle']['type'] ?? 'BUS',
        stopCount: transit['num_stops'] ?? 0,
        departureStop: transit['departure_stop']['name'] ?? '',
        arrivalStop: transit['arrival_stop']['name'] ?? '',
      );
    }

    return TransitStep(
      instructions: instructions,
      duration: duration,
      distance: distance,
      startLocation: LatLng(step['start_location']['lat'].toDouble(), step['start_location']['lng'].toDouble()),
      endLocation: LatLng(step['end_location']['lat'].toDouble(), step['end_location']['lng'].toDouble()),
      polylinePoints: stepPolylinePoints,
      transitDetails: transitDetails,
    );
  }

  Map<String, List<LatLng>> _getKnownTramRoutes() {
    return {
      '1': [
        LatLng(45.55246068712782, 18.729819674727093), // ZELENO POLJE area
        LatLng(45.553892821324794, 18.72498427806678), // Tramvajska stanica Donji Grad
        LatLng(45.55492143882817, 18.720294827667875), // bana Josipa Jelačića
        LatLng(45.55595856522575, 18.71662494313781), // cara Hadrijana
        LatLng(45.55718881584692, 18.711174085262257), // KBC
        LatLng(45.55904098049919, 18.7030606095715), // Remiza
        LatLng(45.558561685960484, 18.69884854392559), // VIM
        LatLng(45.55883901033378, 18.693897587603054), // Europska avenija Tvrđa
        LatLng(45.55962245049111, 18.690176197400707), // Dom zdravlja
        LatLng(45.560411126920656, 18.685826833247457), // Pošta
        LatLng(45.56096092548518, 18.682080945154535), // Sakuntala Park
        LatLng(45.561510196358114, 18.677260528203842), // Trg Ante Starčevića
      ],
      // Future: Add Line 2, Line 3, etc.
      // '2': [
      //   // Line 2 stops...
      // ],
    };
  }

  List<LatLng> _optimizeOsijekTramRoute(
    List<LatLng> originalPoints,
    String lineNumber,
    LatLng departureStop,
    LatLng arrivalStop,
  ) {
    final knownRoutes = _getKnownTramRoutes();
    final cleanLineNumber = lineNumber.replaceAll('Linija ', '').trim();

    if (knownRoutes.containsKey(cleanLineNumber)) {
      final lineStops = knownRoutes[cleanLineNumber]!;

      int startIndex = findClosestStopIndex(departureStop, lineStops);
      int endIndex = findClosestStopIndex(arrivalStop, lineStops);

      final startDistance = calculateDistance(departureStop, lineStops[startIndex]);
      final endDistance = calculateDistance(arrivalStop, lineStops[endIndex]);

      // Distance threshold: 0.001 degrees ≈ 100 meters
      const double distanceThreshold = 0.001;

      if (startDistance < distanceThreshold && endDistance < distanceThreshold) {
        // Ensure correct direction (start should come before end)
        if (startIndex > endIndex) {
          final temp = startIndex;
          startIndex = endIndex;
          endIndex = temp;
        }

        final optimizedRoute = lineStops.sublist(startIndex, endIndex + 1);

        return optimizedRoute;
      }
    }

    return originalPoints;
  }

  int findClosestStopIndex(LatLng target, List<LatLng> stops) {
    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < stops.length; i++) {
      final distance = calculateDistance(target, stops[i]);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    return closestIndex;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    final deltaLat = point1.latitude - point2.latitude;
    final deltaLng = point1.longitude - point2.longitude;
    return deltaLat * deltaLat + deltaLng * deltaLng;
  }

  List<RouteSegment> _createRouteSegments(List<TransitStep> steps) {
    final segments = <RouteSegment>[];

    for (final step in steps) {
      if (step.transitDetails != null) {
        segments.add(
          RouteSegment(
            polylinePoints: step.polylinePoints,
            type: RouteSegmentType.transit,
            lineName: step.transitDetails!.lineShortName.isNotEmpty
                ? step.transitDetails!.lineShortName
                : step.transitDetails!.lineName,
            vehicleType: step.transitDetails!.vehicleType,
          ),
        );
      } else {
        segments.add(RouteSegment(polylinePoints: step.polylinePoints, type: RouteSegmentType.walking));
      }
    }

    return segments;
  }
}

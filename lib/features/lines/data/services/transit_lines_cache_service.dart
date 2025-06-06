import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class TransitLinesCacheService {
  static const String _tramLinesKey = 'cached_tram_lines';
  static const String _busLinesKey = 'cached_bus_lines';
  static const String _lastUpdateKey = 'lines_last_update';
  static const Duration _cacheExpiration = Duration(days: 7);

  Future<Map<String, List<LatLng>>?> getCachedTramLines() async {
    final prefs = await SharedPreferences.getInstance();

    if (!_isCacheValid(prefs)) return null;

    final tramLinesJson = prefs.getString(_tramLinesKey);
    if (tramLinesJson == null) return null;

    return _deserializeLines(tramLinesJson);
  }

  Future<Map<String, List<LatLng>>?> getCachedBusLines() async {
    final prefs = await SharedPreferences.getInstance();

    if (!_isCacheValid(prefs)) return null;

    final busLinesJson = prefs.getString(_busLinesKey);
    if (busLinesJson == null) return null;

    return _deserializeLines(busLinesJson);
  }

  Future<void> cacheTramLines(Map<String, List<LatLng>> tramLines) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _serializeLines(tramLines);

    await prefs.setString(_tramLinesKey, serialized);
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> cacheBusLines(Map<String, List<LatLng>> busLines) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _serializeLines(busLines);

    await prefs.setString(_busLinesKey, serialized);
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  bool _isCacheValid(SharedPreferences prefs) {
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return false;

    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    return DateTime.now().difference(lastUpdateTime) < _cacheExpiration;
  }

  String _serializeLines(Map<String, List<LatLng>> lines) {
    final Map<String, List<Map<String, double>>> serializable = {};

    lines.forEach((lineId, points) {
      serializable[lineId] = points.map((point) => {'lat': point.latitude, 'lng': point.longitude}).toList();
    });

    return jsonEncode(serializable);
  }

  Map<String, List<LatLng>> _deserializeLines(String linesJson) {
    final Map<String, dynamic> data = jsonDecode(linesJson);
    final Map<String, List<LatLng>> lines = {};

    data.forEach((lineId, points) {
      final List<dynamic> pointsList = points as List<dynamic>;
      lines[lineId] = pointsList.map((point) => LatLng(point['lat'] as double, point['lng'] as double)).toList();
    });

    return lines;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tramLinesKey);
    await prefs.remove(_busLinesKey);
    await prefs.remove(_lastUpdateKey);
  }
}

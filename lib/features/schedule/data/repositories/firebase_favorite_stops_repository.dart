import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/services/notification_service.dart';
import 'package:linos/features/schedule/data/models/transit_stop.dart';

@lazySingleton
class FirebaseFavoriteStopsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseFavoriteStopsRepository() : _firestore = FirebaseFirestore.instance, _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _favoriteStopsRef =>
      _firestore.collection('users').doc(_userId).collection('favorite_stops');

  Stream<List<TransitStop>> getFavoriteTramStopsStream() {
    if (_userId.isEmpty) {
      return Stream.value([]);
    }
    return _favoriteStopsRef
        .where('vehicleType', isEqualTo: VehicleType.tram.name)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TransitStop.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Stream<List<TransitStop>> getFavoriteBusStopsStream() {
    if (_userId.isEmpty) {
      return Stream.value([]);
    }
    return _favoriteStopsRef
        .where('vehicleType', isEqualTo: VehicleType.bus.name)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TransitStop.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Stream<List<TransitStop>> getFavoriteStopsByVehicleTypeStream(VehicleType vehicleType) {
    switch (vehicleType) {
      case VehicleType.tram:
        return getFavoriteTramStopsStream();
      case VehicleType.bus:
        return getFavoriteBusStopsStream();
    }
  }

  Future<List<TransitStop>> getFavoriteTramStops() async {
    if (_userId.isEmpty) return [];

    final snapshot = await _favoriteStopsRef
        .where('vehicleType', isEqualTo: VehicleType.tram.name)
        .orderBy('name')
        .get();

    return snapshot.docs.map((doc) => TransitStop.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<List<TransitStop>> getFavoriteBusStops() async {
    if (_userId.isEmpty) return [];

    final snapshot = await _favoriteStopsRef
        .where('vehicleType', isEqualTo: VehicleType.bus.name)
        .orderBy('name')
        .get();

    return snapshot.docs.map((doc) => TransitStop.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<List<TransitStop>> getFavoriteStopsByVehicleType(VehicleType vehicleType) async {
    switch (vehicleType) {
      case VehicleType.tram:
        return await getFavoriteTramStops();
      case VehicleType.bus:
        return await getFavoriteBusStops();
    }
  }

  Future<void> addFavoriteStop(TransitStop stop) async {
    if (_userId.isEmpty) return;

    final stopData = stop.toJson();

    await _favoriteStopsRef.doc(stop.id).set(stopData, SetOptions(merge: true));

    final notificationService = getIt<NotificationService>();
    await notificationService.scheduleNotificationsForFavoriteStop(stop);
  }

  Future<void> removeFavoriteStop(TransitStop stop) async {
    if (_userId.isEmpty) return;

    await _favoriteStopsRef.doc(stop.id).delete();

    final notificationService = getIt<NotificationService>();
    await notificationService.cancelNotificationsForStop(stop.id);
  }

  Future<bool> isFavoriteStop(String stopId) async {
    if (_userId.isEmpty) return false;

    final doc = await _favoriteStopsRef.doc(stopId).get();
    return doc.exists;
  }

  Future<void> ensureUserInitialized() async {
    if (_userId.isEmpty) return;

    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      await userDocRef.set({'email': _auth.currentUser?.email, 'createdAt': FieldValue.serverTimestamp()});
    }
  }
}

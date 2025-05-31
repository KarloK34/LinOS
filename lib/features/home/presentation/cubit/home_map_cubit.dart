import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';

class HomeMapCubit extends Cubit<HomeMapState> {
  HomeMapCubit() : super(HomeMapInitial()) {
    fetchUserLocation();
  }

  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void animateCameraToLocation(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 14.0)));
  }

  Future<void> fetchUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      if (isClosed) return;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (isClosed) return;
        emit(const HomeMapLocationError('Location services are disabled. Please enable them.'));
        return;
      }

      if (isClosed) return;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        if (isClosed) return;
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (isClosed) return;
          emit(const HomeMapLocationError('Location permissions are denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (isClosed) return;
        emit(const HomeMapLocationError('Location permissions are permanently denied, we cannot request permissions.'));
        return;
      }

      if (isClosed) return;
      Position position = await Geolocator.getCurrentPosition();

      final userLocation = LatLng(position.latitude, position.longitude);
      final userCameraPosition = CameraPosition(target: userLocation, zoom: 14);

      if (isClosed) return;
      emit(HomeMapLocationLoaded(userLocation: userLocation, initialCameraPosition: userCameraPosition));
    } catch (e) {
      if (isClosed) return;
      emit(HomeMapLocationError('Failed to get location: \${e.toString()}'));
    }
  }

  void showUserLocationOnMap() {
    if (state is HomeMapLocationLoaded) {
      final loadedState = state as HomeMapLocationLoaded;
      animateCameraToLocation(loadedState.userLocation);
    } else {
      fetchUserLocation();
    }
  }
}

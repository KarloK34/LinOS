import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: BlocBuilder<HomeMapCubit, HomeMapState>(
        builder: (context, state) {
          if (state is HomeMapLocationLoaded) {
            CameraPosition currentCameraPosition = state.initialCameraPosition;

            return GoogleMap(
              initialCameraPosition: currentCameraPosition,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                context.read<HomeMapCubit>().onMapCreated(controller);
                context.read<HomeMapCubit>().fetchUserLocation();
              },
              markers: state.markers.toSet(),
              polylines: state.polylines.toSet(),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

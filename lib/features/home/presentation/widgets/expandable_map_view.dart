import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';

class ExpandableMapView extends StatelessWidget {
  const ExpandableMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenSize.height * 0.35,
      child: Stack(
        children: [
          BlocBuilder<HomeMapCubit, HomeMapState>(
            builder: (context, state) {
              if (state is HomeMapLocationLoaded) {
                return GoogleMap(
                  initialCameraPosition: state.initialCameraPosition,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    context.read<HomeMapCubit>().onMapCreated(controller);
                  },
                  markers: state.markers.toSet(),
                  polylines: state.polylines.toSet(),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: FloatingActionButton.small(
              onPressed: () {
                _showExpandedMap(context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.fullscreen, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _showExpandedMap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                BlocBuilder<HomeMapCubit, HomeMapState>(
                  bloc: context.read<HomeMapCubit>(),
                  builder: (_, state) {
                    if (state is HomeMapLocationLoaded) {
                      return GoogleMap(
                        initialCameraPosition: state.initialCameraPosition,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          context.read<HomeMapCubit>().onMapCreated(controller);
                        },
                        markers: state.markers.toSet(),
                        polylines: state.polylines.toSet(),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FloatingActionButton.small(
                    onPressed: () => context.pop(),
                    backgroundColor: Colors.white,
                    child: Icon(Icons.fullscreen_exit, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

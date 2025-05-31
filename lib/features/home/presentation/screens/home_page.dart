import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/widgets/debounced_search_bar.dart';
import 'package:linos/features/home/data/models/place_suggestion.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_state.dart';
import 'package:linos/features/home/presentation/cubit/transit_route_cubit.dart';
import 'package:linos/features/home/presentation/cubit/transit_route_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlaceSuggestion> suggestions = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeMapCubit>().fetchUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<SearchDestinationCubit, SearchDestinationState>(
            listener: (context, state) {
              if (state is SearchDestinationSelected) {
                context.read<HomeMapCubit>().addDestinationMarker(
                  state.selectedPlace.coordinates,
                  state.selectedPlace.name,
                );
              } else if (state is SearchDestinationInitial) {
                context.read<HomeMapCubit>().clearRoute();
              }
            },
          ),
          BlocListener<TransitRouteCubit, TransitRouteState>(
            listener: (context, state) {
              if (state is TransitRouteLoaded) {
                context.read<HomeMapCubit>().updateTransitRoute(state.route);
              } else if (state is TransitRouteCleared) {
                context.read<HomeMapCubit>().clearRoute();
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
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
              ),
              SizedBox(height: 16.0),
              DebouncedSearchBar(),
              SizedBox(height: 16.0),
              Text(
                context.l10n.homePage_popularDestinationsTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(context.l10n.homePage_popularDestinationsSubtitle),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.place),
                      title: Text(context.l10n.homePage_osijekCitadelTitle),
                      subtitle: Text(context.l10n.homePage_osijekCitadelSubtitle),
                      onTap: () {
                        // Handle tap
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton(onPressed: () {}, child: Text(context.l10n.homePage_startNavigationButton)),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

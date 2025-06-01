import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/home/data/services/navigation_service.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';
import 'package:linos/features/home/presentation/widgets/debounced_search_bar.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/popular_destinations_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_state.dart';
import 'package:linos/features/home/presentation/cubit/transit_route_cubit.dart';
import 'package:linos/features/home/presentation/cubit/transit_route_state.dart';
import 'package:linos/features/home/presentation/widgets/map_view.dart';
import 'package:linos/features/home/presentation/widgets/popular_destinations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _startNavigation(BuildContext context) async {
    final searchState = context.read<SearchDestinationCubit>().state;
    final mapState = context.read<HomeMapCubit>().state;

    if (searchState is SearchDestinationSelected && mapState is HomeMapLocationLoaded) {
      final success = await NavigationService.navigateToDestinationWithTransit(
        origin: mapState.userLocation,
        destination: searchState.selectedPlace.coordinates,
        destinationName: searchState.selectedPlace.name,
      );

      if (!success && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.homePage_navigationError), backgroundColor: Colors.red));
      }
    } else if (context.mounted) {
      String message;
      if (searchState is! SearchDestinationSelected) {
        message = context.l10n.homePage_noDestinationError;
      } else {
        message = context.l10n.homePage_locationError;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.orange));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<SearchDestinationCubit, SearchDestinationState>(
            listener: (context, state) {
              if (state is SearchDestinationSelected) {
                context.read<PopularDestinationsCubit>().addSearchToHistory(state.selectedPlace);
                context.read<HomeMapCubit>().addDestinationMarker(
                  state.selectedPlace.coordinates,
                  state.selectedPlace.name,
                );
              }
              if (state is SearchDestinationInitial) {
                context.read<HomeMapCubit>().clearRoute();
              }
            },
          ),
          BlocListener<TransitRouteCubit, TransitRouteState>(
            listener: (context, state) {
              if (state is TransitRouteLoaded) {
                context.read<HomeMapCubit>().updateTransitRoute(state.route);
              }
              if (state is TransitRouteCleared) {
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
              MapView(),
              SizedBox(height: 16.0),
              DebouncedSearchBar(),
              SizedBox(height: 16.0),
              Expanded(child: PopularDestinations()),
              SizedBox(height: 16.0),
              _buildStartNavigationButton(),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<SearchDestinationCubit, SearchDestinationState> _buildStartNavigationButton() {
    return BlocBuilder<SearchDestinationCubit, SearchDestinationState>(
      builder: (context, searchState) {
        return BlocBuilder<HomeMapCubit, HomeMapState>(
          builder: (context, mapState) {
            final isDestinationSelected = searchState is SearchDestinationSelected;
            final isLocationLoaded = mapState is HomeMapLocationLoaded;
            final isNavigationReady = isDestinationSelected && isLocationLoaded;

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isNavigationReady ? () => _startNavigation(context) : null,
                icon: Icon(Icons.navigation),
                label: Text(context.l10n.homePage_startNavigationButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNavigationReady ? null : Colors.grey,
                  foregroundColor: isNavigationReady ? null : Colors.white70,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

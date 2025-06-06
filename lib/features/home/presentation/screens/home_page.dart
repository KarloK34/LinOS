import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:linos/core/utils/app_error_handler.dart';
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
import 'package:linos/features/home/presentation/widgets/expandable_map_view.dart';
import 'package:linos/features/home/presentation/widgets/popular_destinations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          BlocListener<HomeMapCubit, HomeMapState>(
            listener: (context, state) {
              if (state is HomeMapLocationError) {
                final errorMessage = AppErrorHandler.getLocalizedMessage(context, state.errorKey);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.orange,
                    action: _getSnackBarAction(context, state.errorKey),
                  ),
                );
              }
            },
          ),
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
        child: Column(
          children: [
            ExpandableMapView(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          ],
        ),
      ),
    );
  }

  SnackBarAction? _getSnackBarAction(BuildContext context, String errorKey) {
    if (errorKey == 'location_services_disabled' || errorKey == 'location_permissions_denied_forever') {
      return SnackBarAction(
        label: context.l10n.button_settings,
        textColor: Colors.white,
        onPressed: () => Geolocator.openAppSettings(),
      );
    }
    return SnackBarAction(
      label: context.l10n.button_retry,
      textColor: Colors.white,
      onPressed: () => context.read<HomeMapCubit>().fetchUserLocation(),
    );
  }

  BlocBuilder<SearchDestinationCubit, SearchDestinationState> _buildStartNavigationButton() {
    return BlocBuilder<SearchDestinationCubit, SearchDestinationState>(
      builder: (context, searchState) {
        return BlocBuilder<HomeMapCubit, HomeMapState>(
          builder: (context, mapState) {
            final isDestinationSelected = searchState is SearchDestinationSelected;
            final isLocationLoaded = mapState is HomeMapLocationLoaded;
            final hasLocationError = mapState is HomeMapLocationError;
            final isNavigationReady = isDestinationSelected && isLocationLoaded;

            String buttonText;
            VoidCallback? onPressed;

            if (hasLocationError) {
              buttonText = context.l10n.homePage_fixLocationFirst;
              onPressed = () => context.read<HomeMapCubit>().fetchUserLocation();
            } else if (!isDestinationSelected) {
              buttonText = context.l10n.homePage_selectDestinationFirst;
              onPressed = null;
            } else if (!isLocationLoaded) {
              buttonText = context.l10n.homePage_loadingLocation;
              onPressed = null;
            } else {
              buttonText = context.l10n.homePage_startNavigationButton;
              onPressed = () => _startNavigation(context);
            }

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(hasLocationError ? Icons.location_off : Icons.navigation),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNavigationReady
                      ? null
                      : hasLocationError
                      ? Colors.orange
                      : Colors.grey,
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

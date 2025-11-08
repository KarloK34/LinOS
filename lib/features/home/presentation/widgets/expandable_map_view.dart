import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/home_map_state.dart';
import 'package:geolocator/geolocator.dart';

class ExpandableMapView extends StatelessWidget {
  const ExpandableMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: context.screenSize.height * 0.35,
        child: Stack(
          children: [
            BlocBuilder<HomeMapCubit, HomeMapState>(
              buildWhen: (previous, current) {
                // Only rebuild when state type changes or map data changes
                if (previous.runtimeType != current.runtimeType) return true;
                if (previous is HomeMapLocationLoaded && current is HomeMapLocationLoaded) {
                  // Rebuild only if markers or polylines changed
                  return previous.markers.length != current.markers.length ||
                      previous.polylines.length != current.polylines.length ||
                      previous.markers != current.markers ||
                      previous.polylines != current.polylines;
                }
                return false;
              },
              builder: (context, state) {
                if (state is HomeMapLocationLoaded) {
                  return RepaintBoundary(
                    child: GoogleMap(
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
                    ),
                  );
                }

                if (state is HomeMapLocationError) {
                  return _buildErrorWidget(context, state);
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Only show fullscreen button when map is loaded
            BlocBuilder<HomeMapCubit, HomeMapState>(
              buildWhen: (previous, current) {
                // Only rebuild when state changes to/from loaded state
                final wasLoaded = previous is HomeMapLocationLoaded;
                final isLoaded = current is HomeMapLocationLoaded;
                return wasLoaded != isLoaded;
              },
              builder: (context, state) {
                if (state is HomeMapLocationLoaded) {
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        _showExpandedMap(context);
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.fullscreen, color: Colors.black87),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, HomeMapLocationError state) {
    final errorMessage = AppErrorHandler.getLocalizedMessage(context, state.errorKey);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getErrorIcon(state.errorKey), size: 48, color: Colors.grey[600]),
                const SizedBox(height: 12),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildErrorAction(context, state.errorKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getErrorIcon(String errorKey) {
    switch (errorKey) {
      case 'location_services_disabled':
        return Icons.location_disabled;
      case 'location_permissions_denied':
      case 'location_permissions_denied_forever':
        return Icons.location_off;
      default:
        return Icons.error_outline;
    }
  }

  Widget _buildErrorAction(BuildContext context, String errorKey) {
    if (errorKey == 'location_services_disabled' || errorKey == 'location_permissions_denied_forever') {
      return ElevatedButton.icon(
        onPressed: () => Geolocator.openAppSettings(),
        icon: Icon(Icons.settings, size: 18),
        label: Text(context.l10n.button_settings),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () => context.read<HomeMapCubit>().fetchUserLocation(),
        icon: Icon(Icons.refresh, size: 18),
        label: Text(context.l10n.button_retry),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }
  }

  void _showExpandedMap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, __) => Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                BlocBuilder<HomeMapCubit, HomeMapState>(
                  bloc: context.read<HomeMapCubit>(),
                  buildWhen: (previous, current) {
                    // Only rebuild when state type changes or map data changes
                    if (previous.runtimeType != current.runtimeType) return true;
                    if (previous is HomeMapLocationLoaded && current is HomeMapLocationLoaded) {
                      return previous.markers.length != current.markers.length ||
                          previous.polylines.length != current.polylines.length ||
                          previous.markers != current.markers ||
                          previous.polylines != current.polylines;
                    }
                    return false;
                  },
                  builder: (_, state) {
                    if (state is HomeMapLocationLoaded) {
                      return RepaintBoundary(
                        child: GoogleMap(
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
                        ),
                      );
                    }

                    if (state is HomeMapLocationError) {
                      return _buildFullScreenErrorWidget(context, state);
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FloatingActionButton.small(
                    onPressed: () => context.pop(),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.fullscreen_exit, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildFullScreenErrorWidget(BuildContext context, HomeMapLocationError state) {
    final errorMessage = AppErrorHandler.getLocalizedMessage(context, state.errorKey);

    return RepaintBoundary(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getErrorIcon(state.errorKey), size: 80, color: Colors.grey[600]),
              const SizedBox(height: 24),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              _buildErrorAction(context, state.errorKey),
            ],
          ),
        ),
      ),
    );
  }
}

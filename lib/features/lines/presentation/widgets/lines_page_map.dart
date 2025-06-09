import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_cubit.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_state.dart';

class LinesPageMap extends StatelessWidget {
  LinesPageMap({super.key, required VehicleType selectedLineType}) : _selectedLineType = selectedLineType;

  final VehicleType _selectedLineType;
  final CameraPosition osijekCoordinates = CameraPosition(target: LatLng(45.55111, 18.69389), zoom: 12);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LinesMapCubit, LinesMapState>(
        builder: (context, state) {
          if (state is LinesMapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LinesMapError) {
            final errorMessage = AppErrorHandler.getLocalizedMessage(context, state.errorKey);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(errorMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedLineType == VehicleType.tram) {
                        context.read<LinesMapCubit>().showTramLines();
                      } else {
                        context.read<LinesMapCubit>().showBusLines();
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return GoogleMap(
            initialCameraPosition: osijekCoordinates,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              context.read<LinesMapCubit>().onMapCreated(controller);
            },
            polylines: state is LinesMapLoaded ? state.polylines.toSet() : {},
            markers: state is LinesMapLoaded ? state.vehicleMarkers.toSet() : {},
          );
        },
      ),
    );
  }
}

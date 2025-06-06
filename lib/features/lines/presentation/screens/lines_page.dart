import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/lines/data/enums/line_type.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_cubit.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_state.dart';

class LinesPage extends StatefulWidget {
  const LinesPage({super.key});

  @override
  State<LinesPage> createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {
  late LineType _selectedLineType;

  @override
  void initState() {
    super.initState();
    _selectedLineType = LineType.tram;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LinesMapCubit>().showTramLines();
    });
  }

  @override
  Widget build(BuildContext context) {
    const CameraPosition osijekCoordinates = CameraPosition(target: LatLng(45.55111, 18.69389), zoom: 11);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLineType = LineType.tram;
                      });
                      context.read<LinesMapCubit>().showTramLines();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: context.theme.colorScheme.primaryContainer, width: 1.0),
                        color: _selectedLineType == LineType.tram
                            ? context.theme.colorScheme.primaryContainer
                            : context.theme.colorScheme.surface,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.train, size: 32, color: context.theme.colorScheme.onPrimaryContainer),
                          Text(
                            context.l10n.linesPage_tramLinesTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLineType = LineType.bus;
                      });
                      context.read<LinesMapCubit>().showBusLines();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: context.theme.colorScheme.primaryContainer, width: 1.0),
                        color: _selectedLineType == LineType.bus
                            ? context.theme.colorScheme.primaryContainer
                            : context.theme.colorScheme.surface,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.directions_bus, size: 32, color: context.theme.colorScheme.onPrimaryContainer),
                          Text(
                            context.l10n.linesPage_busLinesTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
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
                              if (_selectedLineType == LineType.tram) {
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
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      context.read<LinesMapCubit>().onMapCreated(controller);
                    },
                    polylines: state is LinesMapLoaded ? state.polylines.toSet() : {},
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FloatingActionButton(onPressed: () {}, child: Text(context.l10n.linesPage_realTimeButton)),
            ),
          ],
        ),
      ),
    );
  }
}

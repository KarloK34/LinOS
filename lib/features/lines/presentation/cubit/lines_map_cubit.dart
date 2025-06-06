import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/services/osijek_transit_data_service.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/features/lines/data/enums/line_type.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_state.dart';
import 'package:linos/features/lines/data/services/transit_lines_api_service.dart';

@lazySingleton
class LinesMapCubit extends Cubit<LinesMapState> {
  final TransitLinesApiService _transitLinesApiService;

  LinesMapCubit(this._transitLinesApiService) : super(LinesMapInitial());

  GoogleMapController? _mapController;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> showTramLines() async {
    if (state is! LinesMapLoaded || (state as LinesMapLoaded).selectedType != LineType.tram) {
      emit(LinesMapLoading());
    }

    try {
      final apiTramRoutes = await _transitLinesApiService.getTramLines();
      final customTramRoutes = OsijekTransitDataService.getTramRoutes();
      final mergedRoutes = <String, List<LatLng>>{...apiTramRoutes, ...customTramRoutes};
      final tramPolylines = _createTramPolylines(mergedRoutes);
      emit(LinesMapLoaded(polylines: tramPolylines, selectedType: LineType.tram));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(LinesMapError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  Future<void> showBusLines() async {
    if (state is! LinesMapLoaded || (state as LinesMapLoaded).selectedType != LineType.bus) {
      emit(LinesMapLoading());
    }

    try {
      final busRoutes = await _transitLinesApiService.getBusLines();
      final busPolylines = _createBusPolylines(busRoutes);
      emit(LinesMapLoaded(polylines: busPolylines, selectedType: LineType.bus));
    } catch (e) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(LinesMapError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, StackTrace.current);
    }
  }

  Future<void> preloadLines() async {
    try {
      await Future.wait([_transitLinesApiService.getTramLines(), _transitLinesApiService.getBusLines()]);
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(LinesMapError(errorKey, originalError: e));
      AppErrorLogger.handleError(errorKey, stackTrace);
    }
  }

  List<Polyline> _createTramPolylines(Map<String, List<LatLng>> tramRoutes) {
    final polylines = <Polyline>[];

    tramRoutes.forEach((lineNumber, stops) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('tram_line_$lineNumber'),
          points: stops,
          color: Colors.red,
          width: 4,
          patterns: [],
        ),
      );
    });

    return polylines;
  }

  List<Polyline> _createBusPolylines(Map<String, List<LatLng>> busRoutes) {
    final polylines = <Polyline>[];

    busRoutes.forEach((lineNumber, stops) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('bus_line_$lineNumber'),
          points: stops,
          color: Colors.blue,
          width: 4,
          patterns: [],
        ),
      );
    });

    return polylines;
  }

  @override
  Future<void> close() {
    _mapController?.dispose();
    return super.close();
  }
}

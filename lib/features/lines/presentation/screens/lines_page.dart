import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/widgets/vehicle_type_selector.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_cubit.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_state.dart';
import 'package:linos/features/lines/presentation/widgets/lines_page_map.dart';

class LinesPage extends StatefulWidget {
  const LinesPage({super.key});

  @override
  State<LinesPage> createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {
  late VehicleType _selectedLineType;

  @override
  void initState() {
    super.initState();
    _selectedLineType = VehicleType.tram;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LinesMapCubit>().showTramLines();
    });
  }

  void _onLineTypeSelected(VehicleType lineType) {
    setState(() {
      _selectedLineType = lineType;
    });

    final cubit = context.read<LinesMapCubit>();
    switch (lineType) {
      case VehicleType.tram:
        cubit.showTramLines();
      case VehicleType.bus:
        cubit.showBusLines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VehicleTypeSelector(
              isTramSelected: _selectedLineType == VehicleType.tram,
              isBusSelected: _selectedLineType == VehicleType.bus,
              onTramSelected: () => _onLineTypeSelected(VehicleType.tram),
              onBusSelected: () => _onLineTypeSelected(VehicleType.bus),
              tramTitle: context.l10n.linesPage_tramLinesTitle,
              busTitle: context.l10n.linesPage_busLinesTitle,
            ),
            SizedBox(height: 16.0),
            LinesPageMap(selectedLineType: _selectedLineType),
            SizedBox(height: 16.0),
            _buildVehicleToggleButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleToggleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: BlocBuilder<LinesMapCubit, LinesMapState>(
        builder: (context, state) {
          final showingVehicles = state is LinesMapLoaded ? state.showVehicles : false;

          return ElevatedButton.icon(
            onPressed: () => context.read<LinesMapCubit>().toggleVehiclePositions(),
            icon: Icon(_getVehicleButtonIcon(showingVehicles)),
            label: Text(_getVehicleButtonText(context, showingVehicles)),
            style: ElevatedButton.styleFrom(backgroundColor: showingVehicles ? Colors.orange : Colors.green),
          );
        },
      ),
    );
  }

  IconData _getVehicleButtonIcon(bool showingVehicles) {
    if (showingVehicles) return Icons.visibility_off;
    return _selectedLineType == VehicleType.bus ? Icons.directions_bus : Icons.train;
  }

  String _getVehicleButtonText(BuildContext context, bool showingVehicles) {
    return showingVehicles ? context.l10n.linesPage_hideVehicles : context.l10n.linesPage_showVehicles;
  }
}

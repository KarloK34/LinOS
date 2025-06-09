import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/lines/data/enums/line_type.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_cubit.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_state.dart';
import 'package:linos/features/lines/presentation/widgets/lines_page_map.dart';

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

  void _onLineTypeSelected(LineType lineType) {
    setState(() {
      _selectedLineType = lineType;
    });

    final cubit = context.read<LinesMapCubit>();
    switch (lineType) {
      case LineType.tram:
        cubit.showTramLines();
      case LineType.bus:
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
            _buildLineTypeSelector(),
            SizedBox(height: 16.0),
            LinesPageMap(selectedLineType: _selectedLineType),
            SizedBox(height: 16.0),
            _buildVehicleToggleButton(),
          ],
        ),
      ),
    );
  }

  Row _buildLineTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _LineTypeTab(
            lineType: LineType.tram,
            icon: Icons.train,
            title: context.l10n.linesPage_tramLinesTitle,
            isSelected: _selectedLineType == LineType.tram,
            onTap: () => _onLineTypeSelected(LineType.tram),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _LineTypeTab(
            lineType: LineType.bus,
            icon: Icons.directions_bus,
            title: context.l10n.linesPage_busLinesTitle,
            isSelected: _selectedLineType == LineType.bus,
            onTap: () => _onLineTypeSelected(LineType.bus),
          ),
        ),
      ],
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
    return _selectedLineType == LineType.bus ? Icons.directions_bus : Icons.train;
  }

  String _getVehicleButtonText(BuildContext context, bool showingVehicles) {
    return showingVehicles ? context.l10n.linesPage_hideVehicles : context.l10n.linesPage_showVehicles;
  }
}

class _LineTypeTab extends StatelessWidget {
  const _LineTypeTab({
    required this.lineType,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final LineType lineType;
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: colorScheme.primaryContainer, width: 1.0),
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: colorScheme.onPrimaryContainer),
            Text(
              title,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

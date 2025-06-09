import 'package:flutter/material.dart';
import 'package:linos/core/widgets/vehicle_tab.dart';

class VehicleTypeSelector extends StatelessWidget {
  const VehicleTypeSelector({
    super.key,
    required this.isTramSelected,
    required this.isBusSelected,
    required this.onTramSelected,
    required this.onBusSelected,
    required this.tramTitle,
    required this.busTitle,
  });
  final bool isTramSelected;
  final bool isBusSelected;
  final VoidCallback onTramSelected;
  final VoidCallback onBusSelected;
  final String tramTitle;
  final String busTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VehicleTab(icon: Icons.train, title: tramTitle, isSelected: isTramSelected, onTap: onTramSelected),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: VehicleTab(
            icon: Icons.directions_bus,
            title: busTitle,
            isSelected: isBusSelected,
            onTap: onBusSelected,
          ),
        ),
      ],
    );
  }
}

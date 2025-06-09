import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

class VehicleTab extends StatelessWidget {
  const VehicleTab({super.key, required this.icon, required this.title, required this.isSelected, required this.onTap});

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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final EdgeInsets? padding;

  const ErrorState({super.key, required this.title, required this.message, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 8),
            Text(title, style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.red)),
            Text(message, style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.red, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

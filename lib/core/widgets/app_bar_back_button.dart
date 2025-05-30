import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBarBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onPressed ?? () => context.pop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}

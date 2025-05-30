import 'package:flutter/material.dart';

class CustomEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  const CustomEmailField({
    super.key,
    required this.controller,
    required this.labelText,
    this.errorText,
    required this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(labelText: labelText, errorText: errorText),
      onChanged: onChanged,
    );
  }
}

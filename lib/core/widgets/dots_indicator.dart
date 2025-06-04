import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

class DotsIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Function(int) onDotTapped;

  const DotsIndicator({super.key, required this.itemCount, required this.currentIndex, required this.onDotTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => GestureDetector(
          onTap: () => onDotTapped(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: currentIndex == index ? 12 : 8,
            height: currentIndex == index ? 12 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}

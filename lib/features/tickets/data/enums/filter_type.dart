import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

enum FilterType {
  all,
  singleRide,
  dailyPass,
  weeklyPass,
  monthlyPass;

  String camelCaseName(BuildContext context) {
    switch (this) {
      case FilterType.all:
        return context.l10n.all;
      case FilterType.singleRide:
        return context.l10n.singleRide;
      case FilterType.dailyPass:
        return context.l10n.dailyPass;
      case FilterType.weeklyPass:
        return context.l10n.weeklyPass;
      case FilterType.monthlyPass:
        return context.l10n.monthlyPass;
    }
  }
}

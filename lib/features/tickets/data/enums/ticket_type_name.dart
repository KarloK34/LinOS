import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

enum TicketTypeName {
  singleRide,
  dayPass,
  weeklyPass,
  monthlyPass;

  String displayName(BuildContext context) {
    switch (this) {
      case TicketTypeName.singleRide:
        return context.l10n.singleRide;
      case TicketTypeName.dayPass:
        return context.l10n.dailyPass;
      case TicketTypeName.weeklyPass:
        return context.l10n.weeklyPass;
      case TicketTypeName.monthlyPass:
        return context.l10n.monthlyPass;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

class ErrorMessageHelper {
  static String getLocalizedErrorMessage(BuildContext context, String error) {
    final parts = error.split('|');
    final errorType = parts.first;
    final errorDetails = parts.length > 1 ? parts[1] : '';

    switch (errorType) {
      case 'insufficient_balance':
        return context.l10n.error_insufficientBalance;
      case 'purchase_ticket_failed':
        return context.l10n.error_purchaseTicketFailed(errorDetails);
      case 'add_balance_failed':
        return context.l10n.error_addBalanceFailed(errorDetails);
      case 'load_user_data_failed':
        return context.l10n.error_loadUserDataFailed(errorDetails);
      case 'use_ticket_failed':
        return context.l10n.error_useTicketFailed(errorDetails);
      default:
        return error;
    }
  }
}

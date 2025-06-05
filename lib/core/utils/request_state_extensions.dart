import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/app_error_handler.dart';

extension RequestStateExtensions<T> on RequestState<T> {
  String? getErrorMessage(BuildContext context) {
    if (this is RequestError<T>) {
      final error = this as RequestError<T>;

      if (error.message != null) {
        return error.message;
      } else {
        return AppErrorHandler.getLocalizedMessage(context, error.originalError ?? error.errorKey);
      }
    }
    return null;
  }

  void showErrorSnackBar(BuildContext context) {
    final errorMessage = getErrorMessage(context);
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  void showErrorDialog(BuildContext context, {VoidCallback? onRetry}) {
    final errorMessage = getErrorMessage(context);
    if (errorMessage != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.error_title),
          content: Text(errorMessage),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  context.pop();
                  onRetry();
                },
                child: Text(context.l10n.button_retry),
              ),
            TextButton(onPressed: () => context.pop(), child: Text(context.l10n.button_close)),
          ],
        ),
      );
    }
  }
}

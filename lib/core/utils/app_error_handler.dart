import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:linos/core/utils/context_extensions.dart';

class AppErrorHandler {
  static String getErrorKey(dynamic error) {
    if (error is String) {
      return _handleStringError(error);
    }

    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthError(error);
    }

    if (error is DioException) {
      return _handleNetworkError(error);
    }

    if (error is LocationServiceDisabledException) {
      return 'location_services_disabled';
    }

    return 'error_generic';
  }

  static String _handleStringError(String error) {
    final parts = error.split('|');
    final errorType = parts.first;

    switch (errorType) {
      case 'insufficient_balance':
        return 'error_insufficientBalance';
      case 'purchase_ticket_failed':
        return 'error_purchaseTicketFailed';
      case 'add_balance_failed':
        return 'error_addBalanceFailed';
      case 'load_user_data_failed':
        return 'error_loadUserDataFailed';
      case 'use_ticket_failed':
        return 'error_useTicketFailed';
      case 'loading_tickets':
        return 'error_loadingTickets';
      default:
        return 'error_generic';
    }
  }

  static String _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'auth_error_userNotFound';
      case 'wrong-password':
        return 'auth_error_wrongPassword';
      case 'email-already-in-use':
        return 'auth_error_emailAlreadyInUse';
      case 'invalid-email':
        return 'auth_error_invalidEmail';
      case 'weak-password':
        return 'auth_error_weakPassword';
      case 'user-disabled':
        return 'auth_error_userDisabled';
      case 'too-many-requests':
        return 'auth_error_tooManyRequests';
      case 'invalid-credential':
        return 'auth_error_invalidCredentials';
      default:
        return 'auth_error_default';
    }
  }

  static String _handleNetworkError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'error_connectionTimeout';
      case DioExceptionType.connectionError:
        return 'error_noInternet';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'error_sessionExpired';
        } else if (statusCode == 403) {
          return 'error_accessDenied';
        } else if (statusCode == 404) {
          return 'error_resourceNotFound';
        } else if (statusCode != null && statusCode >= 500) {
          return 'error_serverError';
        }
        return 'error_requestFailed';
      default:
        return 'error_generic';
    }
  }

  static String getLocationErrorKey(String locationError) {
    if (locationError.contains('Location services are disabled')) {
      return 'location_services_disabled';
    } else if (locationError.contains('Location permissions are denied') && locationError.contains('permanently')) {
      return 'location_permissions_denied_forever';
    } else if (locationError.contains('Location permissions are denied')) {
      return 'location_permissions_denied';
    } else if (locationError.contains('Failed to get location')) {
      return 'location_failed_to_get';
    }
    return 'error_generic';
  }

  static String getLocalizedMessage(BuildContext context, dynamic error) {
    final errorKey = getErrorKey(error);
    return _getLocalizedMessageFromKey(context, errorKey, error);
  }

  static String _getLocalizedMessageFromKey(BuildContext context, String key, dynamic originalError) {
    switch (key) {
      case 'error_insufficientBalance':
        return context.l10n.error_insufficientBalance;
      case 'error_purchaseTicketFailed':
        final details = _extractErrorDetails(originalError);
        return context.l10n.error_purchaseTicketFailed(details);
      case 'error_addBalanceFailed':
        final details = _extractErrorDetails(originalError);
        return context.l10n.error_addBalanceFailed(details);
      case 'auth_error_userNotFound':
        return context.l10n.auth_error_userNotFound;
      case 'auth_error_wrongPassword':
        return context.l10n.auth_error_wrongPassword;
      case 'auth_error_invalidCredentials':
        return context.l10n.loginPage_error_invalidCredentials;
      case 'error_connectionTimeout':
        return context.l10n.error_connectionTimeout;
      case 'error_noInternet':
        return context.l10n.error_noInternet;
      case 'error_sessionExpired':
        return context.l10n.error_sessionExpired;
      case 'error_accessDenied':
        return context.l10n.error_accessDenied;
      case 'error_resourceNotFound':
        return context.l10n.error_resourceNotFound;
      case 'error_serverError':
        return context.l10n.error_serverError;
      case 'error_requestFailed':
        return context.l10n.error_requestFailed;
      case 'location_services_disabled':
        return context.l10n.location_services_disabled;
      case 'location_permissions_denied':
        return context.l10n.location_permissions_denied;
      case 'location_permissions_denied_forever':
        return context.l10n.location_permissions_denied_forever;
      case 'location_failed_to_get':
        return context.l10n.location_failed_to_get;
      default:
        return context.l10n.validation_unexpectedErrorPrefix + originalError.toString();
    }
  }

  static String _extractErrorDetails(dynamic error) {
    if (error is String && error.contains('|')) {
      final parts = error.split('|');
      return parts.length > 1 ? parts[1] : '';
    }
    return '';
  }

  static void showErrorDialog(BuildContext context, dynamic error, {VoidCallback? onRetry}) {
    final message = getLocalizedMessage(context, error);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.error_title),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: Text(context.l10n.button_retry),
            ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.button_close)),
        ],
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getLocalizedMessage(context, error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: context.l10n.button_close,
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}

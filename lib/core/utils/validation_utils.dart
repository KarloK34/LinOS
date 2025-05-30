import 'package:linos/l10n/app_localizations.dart';

abstract class ValidationUtils {
  static String? validateEmail(String email, AppLocalizations l10n) {
    if (email.isEmpty) {
      return l10n.validation_emailCannotBeEmpty;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return l10n.validation_enterValidEmail;
    }
    return null; // No error
  }

  static String? validatePassword(String password, AppLocalizations l10n) {
    if (password.isEmpty) {
      return l10n.validation_passwordCannotBeEmpty;
    }
    if (password.length < 6) {
      return l10n.validation_passwordTooShort;
    }
    return null; // No error
  }

  static String? validateConfirmPassword(String password, String confirmPassword, AppLocalizations l10n) {
    if (confirmPassword.isEmpty) {
      return l10n.validation_confirmPasswordCannotBeEmpty;
    }
    if (password != confirmPassword) {
      return l10n.validation_passwordsDoNotMatch;
    }
    return null; // No error
  }
}

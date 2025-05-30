import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/validation_utils.dart';
import 'package:linos/features/register/cubit/register_form_state.dart';
import 'package:linos/l10n/app_localizations.dart'; // Import AppLocalizations

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(RegisterFormState.initial());

  void emailChanged(String value, AppLocalizations l10n) {
    // Add l10n parameter
    final emailError = ValidationUtils.validateEmail(value, l10n); // Pass l10n
    emit(state.copyWith(email: value, emailError: emailError));
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    // Add l10n parameter
    final passwordError = ValidationUtils.validatePassword(value, l10n); // Pass l10n
    emit(state.copyWith(password: value, passwordError: passwordError));
  }

  void confirmPasswordChanged(String value, AppLocalizations l10n) {
    // Add l10n parameter
    final confirmPasswordError = ValidationUtils.validateConfirmPassword(state.password, value, l10n); // Pass l10n
    emit(state.copyWith(confirmPassword: value, confirmPasswordError: confirmPasswordError));
  }

  void processRegistration(AppLocalizations l10n) {
    // Add l10n parameter
    final emailError = ValidationUtils.validateEmail(state.email, l10n); // Pass l10n
    final passwordError = ValidationUtils.validatePassword(state.password, l10n); // Pass l10n
    final confirmPasswordError = ValidationUtils.validateConfirmPassword(
      state.password,
      state.confirmPassword,
      l10n,
    ); // Pass l10n

    if (emailError != null || passwordError != null || confirmPasswordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
          submissionStatus: RequestError<bool>(l10n.validation_fixFormErrors), // Use localized string
        ),
      );
      return;
    }
    emit(state.copyWith(submissionStatus: const RequestLoading<bool>()));
    try {
      // Simulate an API call for registration
      // In a real app, you'd call your AuthRepository here
      Future.delayed(const Duration(seconds: 2), () {
        // Simulate successful registration
        emit(state.copyWith(submissionStatus: const RequestSuccess<bool>(true)));
      });
    } catch (e) {
      // Handle any unexpected errors during the submission
      emit(
        state.copyWith(submissionStatus: RequestError<bool>('${l10n.validation_unexpectedErrorPrefix}${e.toString()}')),
      ); // Use localized string
    }
  }
}

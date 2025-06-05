import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/validation_utils.dart';
import 'package:linos/features/auth/data/repositories/auth_repository.dart';
import 'package:linos/features/auth/presentation/register/cubit/register_form_state.dart';
import 'package:linos/l10n/app_localizations.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  final AuthRepository _authRepository;

  RegisterFormCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(FirebaseAuth.instance),
      super(RegisterFormState.initial());

  void emailChanged(String value, AppLocalizations l10n) {
    final emailError = ValidationUtils.validateEmail(value, l10n);
    emit(state.copyWith(email: value, emailError: emailError));
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    final passwordError = ValidationUtils.validatePassword(value, l10n);
    emit(state.copyWith(password: value, passwordError: passwordError));
  }

  void confirmPasswordChanged(String value, AppLocalizations l10n) {
    final confirmPasswordError = ValidationUtils.validateConfirmPassword(state.password, value, l10n);
    emit(state.copyWith(confirmPassword: value, confirmPasswordError: confirmPasswordError));
  }

  Future<void> processRegistration(AppLocalizations l10n) async {
    final emailError = ValidationUtils.validateEmail(state.email, l10n);
    final passwordError = ValidationUtils.validatePassword(state.password, l10n);
    final confirmPasswordError = ValidationUtils.validateConfirmPassword(state.password, state.confirmPassword, l10n);

    if (emailError != null || passwordError != null || confirmPasswordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
          submissionStatus: RequestError.withMessage(l10n.validation_fixFormErrors),
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: const RequestLoading<bool>()));

    try {
      await _authRepository.createUserWithEmailAndPassword(email: state.email, password: state.password);
      emit(state.copyWith(submissionStatus: const RequestSuccess<bool>(true)));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(state.copyWith(submissionStatus: RequestError<bool>(errorKey, originalError: e)));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }
}

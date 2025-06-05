import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/validation_utils.dart';
import 'package:linos/features/auth/data/repositories/auth_repository.dart';
import 'package:linos/features/auth/presentation/login/cubit/login_form_state.dart';
import 'package:linos/l10n/app_localizations.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  final AuthRepository _authRepository;

  LoginFormCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(FirebaseAuth.instance),
      super(LoginFormState.initial());

  void emailChanged(String value, AppLocalizations l10n) {
    final emailError = ValidationUtils.validateEmail(value, l10n);
    emit(state.copyWith(email: value, emailError: emailError));
  }

  void passwordChanged(String value, AppLocalizations l10n) {
    final passwordError = ValidationUtils.validatePassword(value, l10n);
    emit(state.copyWith(password: value, passwordError: passwordError));
  }

  Future<void> processLogin(AppLocalizations l10n) async {
    final emailError = ValidationUtils.validateEmail(state.email, l10n);
    final passwordError = ValidationUtils.validatePassword(state.password, l10n);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          submissionStatus: RequestError.withMessage(l10n.validation_fixFormErrors),
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: const RequestLoading<bool>()));

    try {
      await _authRepository.signInWithEmailAndPassword(email: state.email, password: state.password);
      emit(state.copyWith(submissionStatus: const RequestSuccess<bool>(true)));
    } catch (e, stackTrace) {
      final errorKey = AppErrorHandler.getErrorKey(e);
      emit(state.copyWith(submissionStatus: RequestError<bool>(errorKey, originalError: e)));
      AppErrorLogger.handleError(e, stackTrace);
    }
  }
}

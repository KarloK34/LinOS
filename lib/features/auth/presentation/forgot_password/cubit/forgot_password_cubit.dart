import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/validation_utils.dart';
import 'package:linos/features/auth/data/repositories/auth_repository.dart';
import 'package:linos/features/auth/presentation/forgot_password/cubit/forgot_password_state.dart';
import 'package:linos/l10n/app_localizations.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository) : super(ForgotPasswordState.initial());

  void emailChanged(String value, AppLocalizations l10n) {
    final emailError = ValidationUtils.validateEmail(value, l10n);
    emit(state.copyWith(email: value, emailError: emailError));
  }

  Future<void> resetPassword(AppLocalizations l10n) async {
    final emailError = ValidationUtils.validateEmail(state.email, l10n);

    if (emailError != null) {
      emit(state.copyWith(emailError: emailError, submissionStatus: RequestError<bool>(l10n.validation_fixFormErrors)));
      return;
    }

    emit(state.copyWith(submissionStatus: const RequestLoading<bool>()));

    try {
      await _authRepository.resetPassword(state.email);
      emit(state.copyWith(submissionStatus: const RequestSuccess<bool>(true)));
    } catch (e) {
      emit(state.copyWith(submissionStatus: RequestError<bool>(e.toString())));
    }
  }
}

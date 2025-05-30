import 'package:linos/core/utils/request_state.dart';

class ForgotPasswordState {
  final String email;
  final String? emailError;
  final RequestState<bool> submissionStatus;

  ForgotPasswordState({required this.email, this.emailError, this.submissionStatus = const RequestInitial<bool>()});

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(email: '', emailError: null, submissionStatus: const RequestInitial<bool>());
  }

  ForgotPasswordState copyWith({String? email, String? emailError, RequestState<bool>? submissionStatus}) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  bool get isValid => emailError == null;
}

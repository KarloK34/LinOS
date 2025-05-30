import 'package:linos/core/utils/request_state.dart';

class RegisterFormState {
  final String email;
  final String password;
  final String confirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final RequestState<bool> submissionStatus;

  RegisterFormState({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.submissionStatus = const RequestInitial<bool>(),
  });

  factory RegisterFormState.initial() {
    return RegisterFormState(
      email: '',
      password: '',
      confirmPassword: '',
      emailError: null,
      passwordError: null,
      confirmPasswordError: null,
      submissionStatus: const RequestInitial<bool>(),
    );
  }

  bool get isValid =>
      email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword;

  RegisterFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    RequestState<bool>? submissionStatus,
  }) {
    return RegisterFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}

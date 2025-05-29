import 'package:equatable/equatable.dart';
import 'package:linos/core/utils/request_state.dart';

class LoginFormState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final RequestState<bool> submissionStatus;

  const LoginFormState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
    this.submissionStatus = const RequestInitial<bool>(),
  });

  factory LoginFormState.initial() {
    return const LoginFormState(
      email: '',
      password: '',
      emailError: null,
      passwordError: null,
      submissionStatus: RequestInitial<bool>(),
    );
  }

  LoginFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    RequestState<bool>? submissionStatus,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  bool get isValid => emailError == null && passwordError == null;

  @override
  List<Object?> get props => [email, password, emailError, passwordError, submissionStatus];
}

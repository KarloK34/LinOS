import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/features/login/cubit/login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(LoginFormState.initial());

  void emailChanged(String value) {
    final emailError = _validateEmail(value);
    emit(state.copyWith(email: value, emailError: emailError));
  }

  void passwordChanged(String value) {
    final passwordError = _validatePassword(value);
    emit(state.copyWith(password: value, passwordError: passwordError));
  }

  Future<void> submitForm() async {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          submissionStatus: const RequestError<bool>('Please fix the form errors.'),
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: const RequestLoading<bool>()));

    try {
      // Simulate an API call for login
      // In a real app, you'd call your AuthRepository here
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Simulate successful login for specific credentials
      if (state.email == 'test@example.com' && state.password == 'password123') {
        emit(state.copyWith(submissionStatus: const RequestSuccess<bool>(true)));
      } else {
        // Simulate incorrect credentials
        emit(state.copyWith(submissionStatus: const RequestError<bool>('Invalid email or password.')));
      }
    } catch (e) {
      // Handle any unexpected errors during the submission
      emit(state.copyWith(submissionStatus: RequestError<bool>('An unexpected error occurred: ${e.toString()}')));
    }
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null; // No error
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null; // No error
  }
}

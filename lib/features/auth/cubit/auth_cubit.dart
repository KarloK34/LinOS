import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';
import 'package:linos/features/auth/data/repositories/auth_repository.dart';
import 'package:linos/features/tickets/data/repositories/firebase_tickets_repository.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    _init();
  }

  void _init() {
    _authRepository.authStateChanges.listen((User? user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      emit(const AuthLoading());
      await _authRepository.signInWithEmailAndPassword(email: email, password: password);
      await getIt<FirebaseTicketsRepository>().ensureUserInitialized();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(const AuthLoading());
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(const AuthLoading());
      await _authRepository.resetPassword(email);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

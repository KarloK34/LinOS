import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/navigation/main_page.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';
import 'package:linos/features/auth/presentation/screens/login_page.dart';
import 'package:linos/features/auth/presentation/screens/register_page.dart';

@singleton
class AppRouterConfig {
  static const String mainPage = '/main_page';
  static const String login = '/login';
  static const String register = '/register';

  GoRouter get router => GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: mainPage, builder: (context, state) => const MainPage()),
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
      GoRoute(path: register, builder: (context, state) => const RegisterPage()),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;
      final isLoginRoute = state.matchedLocation == login;
      final isRegisterRoute = state.matchedLocation == register;

      return switch (authState) {
        Authenticated() when isLoginRoute || isRegisterRoute => mainPage,
        Unauthenticated() when !isLoginRoute && !isRegisterRoute => login,
        _ => null,
      };
    },
  );
}

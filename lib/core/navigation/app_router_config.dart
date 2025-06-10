import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/navigation/main_page.dart';
import 'package:linos/features/auth/cubit/auth_cubit.dart';
import 'package:linos/features/auth/cubit/auth_state.dart';
import 'package:linos/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:linos/features/auth/presentation/screens/login_page.dart';
import 'package:linos/features/auth/presentation/screens/register_page.dart';
import 'package:linos/features/tickets/data/repositories/firebase_tickets_repository.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/screens/ticket_history_page.dart';

@singleton
class AppRouterConfig {
  static const String mainPage = '/main_page';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '$login/forgot_password';
  static const String ticketsHistory = '$mainPage/tickets_history';

  GoRouter get router => GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: mainPage,
        builder: (context, state) => const MainPage(),
        routes: [
          GoRoute(
            path: 'tickets_history',
            builder: (context, state) => BlocProvider(
              create: (context) => TicketsCubit(getIt<FirebaseTicketsRepository>()),
              child: TicketHistoryPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
        routes: [GoRoute(path: 'forgot_password', builder: (context, state) => const ForgotPasswordPage())],
      ),
      GoRoute(path: register, builder: (context, state) => const RegisterPage()),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;
      final isLoginRoute = state.matchedLocation == login;
      final isRegisterRoute = state.matchedLocation == register;
      final isForgotPasswordRoute = state.matchedLocation == forgotPassword;

      return switch (authState) {
        Authenticated() when isLoginRoute || isRegisterRoute => mainPage,
        Unauthenticated() when !isLoginRoute && !isRegisterRoute && !isForgotPasswordRoute => login,
        _ => null,
      };
    },
  );
}

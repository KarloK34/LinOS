import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/main_page.dart';
import 'package:linos/features/login/presentation/screens/login_page.dart';
import 'package:linos/features/register/presentation/screens/register_page.dart';

class AppRoutes {
  static const String mainPage = '/main_page';
  static const String login = '/login';
  static const String register = '/register';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: mainPage, builder: (context, state) => const MainPage()),
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
      GoRoute(path: register, builder: (context, state) => const RegisterPage()),
    ],
  );
}

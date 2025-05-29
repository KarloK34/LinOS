import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/main_page.dart';
import 'package:linos/features/login/presentation/login_page.dart';

class AppRoutes {
  static const String mainPage = '/main_page';
  static const String login = '/login';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: mainPage, builder: (context, state) => const MainPage()),
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
    ],
  );
}

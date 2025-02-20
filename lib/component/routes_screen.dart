import 'package:app_task/app/create_task/create_task_view.dart';
import 'package:app_task/auth/login/login_screen_view.dart';
import 'package:app_task/app/presentation/profile/profile_screen_view.dart';
import 'package:app_task/app/profile_view/settings/settings_view_screen.dart';
import 'package:app_task/auth/signUp/singup_view_screen.dart';
import 'package:go_router/go_router.dart';

import '../app/presentation/home/home_screen.dart';
import '../app/presentation/screen_launcher/screen_launcher_view.dart';
import '../main.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ScreenLauncherView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreenView(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpScreenView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreenView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsViewScreen(),
    ),
    GoRoute(
      path: '/createTask',
      builder: (context, state) => CreateTaskView(),
    ),
  ],
);

class LoggerX {
  static void write(String text, {bool isError = false}) {
    Future.microtask(() => isError ? log.v(text) : log.i(text));
  }
}

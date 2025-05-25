import 'package:go_router/go_router.dart';
import 'package:mental_care_chat_demo/view/login/login_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
  ]
);
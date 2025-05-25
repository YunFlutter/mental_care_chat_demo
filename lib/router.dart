import 'package:go_router/go_router.dart';
import 'package:mental_care_chat_demo/view/login/login_screen.dart';
import 'package:mental_care_chat_demo/view/sign_up/sign_up_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);

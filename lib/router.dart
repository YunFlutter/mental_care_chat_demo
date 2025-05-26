import 'package:go_router/go_router.dart';
import 'package:mental_care_chat_demo/view/cesd/cesd_screen.dart';
import 'package:mental_care_chat_demo/view/home/home_empty_screen.dart';
import 'package:mental_care_chat_demo/view/home/home_screen.dart';
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
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/home-empty', builder: (context, state) => const HomeEmptyScreen()),
    GoRoute(path: '/cesd', builder: (context, state) => const CesdScreen())

  ],
);

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/dog_list_page.dart';
import 'detail_page.dart';
import 'widgets_demo_screen.dart';
import 'pages/login_page.dart';
import 'pages/evidence_page.dart';
import 'pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      // Start the app on the login screen so the user sees it first
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const DogListPage(),
        ),
        GoRoute(
          path: '/dog/:id',
          name: 'dogDetail',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '0';
            final extra = state.extra;
            final imageUrl = extra is String ? extra : null;
            return DetailPage(id: id, imageUrl: imageUrl);
          },
        ),
        GoRoute(
          path: '/widgets',
          builder: (context, state) => const WidgetsDemoScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/evidence',
          name: 'evidence',
          builder: (context, state) => const EvidencePage(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.teal),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
    );
  }
}

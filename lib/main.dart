import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/dog_list_page.dart';
import 'detail_page.dart';
import 'widgets_demo_screen.dart';
import 'pages/login_page.dart';
import 'pages/evidence_page.dart';
import 'pages/signup_page.dart';
import 'pages/universities_list_page.dart';
import 'pages/university_form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Initialization failed (e.g., no firebase_options configured) — proceed
    // so the rest of the app can run, Firestore features will show their own errors.
    // Optionally log the error during development.
    // print('Firebase init error: $e');
  }
  runApp(const MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase is initialized in main(); if it isn't configured the app will
    // still start but Firestore features will report errors at usage time.

    final GoRouter router = GoRouter(
      // Start the app on the universidades listing
      initialLocation: '/universidades',
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
          path: '/universidades',
          name: 'universidades',
          builder: (context, state) => UniversitiesListPage(),
        ),
        GoRoute(
          path: '/universidades/new',
          name: 'universidades_new',
          builder: (context, state) => const UniversityFormPage(),
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

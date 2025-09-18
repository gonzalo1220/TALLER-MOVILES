import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_page.dart';
import 'detail_page.dart';
import 'widgets_demo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/detail',
          builder: (context, state) => const DetailPage(),
        ),
        GoRoute(
          path: '/widgets',
          builder: (context, state) => const WidgetsDemoScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

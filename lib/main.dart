import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/dog_list_page.dart';
import 'detail_page.dart';
import 'widgets_demo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
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
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

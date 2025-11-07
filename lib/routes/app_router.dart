// ignore_for_file: non_constant_identifier_names

import 'package:go_router/go_router.dart';
import 'package:hola_mundo/views/categoria_fb/categoria_fb_form_view.dart';
import 'package:hola_mundo/views/categoria_fb/categoria_fb_list_view.dart';

/// Routes used by the application. Import `appRoutes` where needed and
/// merge with other routes if necessary.
final List<GoRoute> appRoutes = [
  GoRoute(
    path: '/categoriasFirebase',
    name: 'categoriasFirebase',
    builder: (context, state) => const CategoriaFbListView(),
  ),
  GoRoute(
    path: '/categoriasfb/create',
    name: 'categoriasfb.create',
    builder: (context, state) => const CategoriaFbFormView(),
  ),
  GoRoute(
    path: '/categoriasfb/edit/:id',
    name: 'categorias.edit',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return CategoriaFbFormView(id: id);
    },
  ),
];

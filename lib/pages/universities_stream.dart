import 'package:flutter/material.dart';

import '../services/university_service.dart';
import '../models/university.dart';

class UniversitiesStream extends StatelessWidget {
  final UniversityService _service = UniversityService();

  UniversitiesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<University>>(
      stream: _service.streamUniversities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const Center(child: Text('No hay universidades'));
        }
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final u = list[index];
            return ListTile(
              dense: true,
              title: Text(u.nombre),
              subtitle: Text(u.paginaWeb),
            );
          },
        );
      },
    );
  }
}

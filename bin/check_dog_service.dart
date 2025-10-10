import 'dart:io';

import 'package:hola_mundo/services/dog_service.dart';

// Small console demo to show loading/success/error when calling the DogService.
Future<void> main() async {
  final service = DogService();
  stdout.writeln('Estado: loading');
  try {
    final res = await service.fetchAfghanHoundImages();
    stdout.writeln('Estado: success');
    stdout.writeln('Número de imágenes: ${res.images.length}');
    // Print first 5 images
    final count = res.images.length < 5 ? res.images.length : 5;
    for (var i = 0; i < count; i++) {
      stdout.writeln('  #${i + 1}: ${res.images[i]}');
    }
  } catch (e) {
    stdout.writeln('Estado: error');
    stdout.writeln('Detalle del error: ${e.toString()}');
  }
}

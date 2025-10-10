import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dog_images_response.dart';

class DogService {
  static const String _baseUrl = 'https://dog.ceo/api';

  Future<DogImagesResponse> fetchAfghanHoundImages() async {
    final uri = Uri.parse('$_baseUrl/breed/hound/afghan/images');
    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(resp.body);
        return DogImagesResponse.fromJson(json);
      } else {
        throw Exception('Server returned ${resp.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

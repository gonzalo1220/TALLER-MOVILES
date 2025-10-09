import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/dog_service.dart';

enum _ViewState { loading, success, error }

class DogListPage extends StatefulWidget {
  const DogListPage({super.key});

  @override
  State<DogListPage> createState() => _DogListPageState();
}

class _DogListPageState extends State<DogListPage> {
  final DogService _service = DogService();
  _ViewState _state = _ViewState.loading;
  List<String> _images = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() {
      _state = _ViewState.loading;
      _errorMessage = '';
    });

    try {
      final res = await _service.fetchAfghanHoundImages();
      setState(() {
        _images = res.images;
        _state = _ViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al obtener imágenes: ${e.toString()}';
        _state = _ViewState.error;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de red: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Afghan Hound Images')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_state == _ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state == _ViewState.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadImages,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _images.length,
      itemBuilder: (context, index) {
        final imageUrl = _images[index];
        return ListTile(
          leading: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image_not_supported),
                )
              : const Icon(Icons.image),
          title: Text('Afghan Hound #${index + 1}'),
          subtitle: Text(imageUrl),
          onTap: () {
            // Navigate to detail passing params (index and url) via path and extra
            context.push('/dog/$index', extra: imageUrl);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/university.dart';
import '../services/university_service.dart';

class UniversityFormPage extends StatefulWidget {
  // If `id` is provided the form will load the university and perform an update.
  final String? id;

  const UniversityFormPage({super.key, this.id});

  @override
  State<UniversityFormPage> createState() => _UniversityFormPageState();
}

class _UniversityFormPageState extends State<UniversityFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nit = TextEditingController();
  final _nombre = TextEditingController();
  final _direccion = TextEditingController();
  final _telefono = TextEditingController();
  final _pagina = TextEditingController();
  final _service = UniversityService();

  bool _loading = false;
  bool _loadingData = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.id!.isNotEmpty) {
      _loadData(widget.id!);
    }
  }

  @override
  void dispose() {
    _nit.dispose();
    _nombre.dispose();
    _direccion.dispose();
    _telefono.dispose();
    _pagina.dispose();
    super.dispose();
  }

  Future<void> _loadData(String id) async {
    setState(() {
      _loadingData = true;
    });
    try {
      final u = await _service.getUniversityById(id);
      _nit.text = u.nit;
      _nombre.text = u.nombre;
      _direccion.text = u.direccion;
      _telefono.text = u.telefono;
      _pagina.text = u.paginaWeb;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cargar la universidad: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingData = false;
        });
      }
    }
  }

  String? _validateNotEmpty(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Este campo es requerido' : null;

  String? _validateUrl(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    final uri = Uri.tryParse(v);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return 'Ingrese una URL válida';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      final u = University(
        id: widget.id ?? '',
        nit: _nit.text.trim(),
        nombre: _nombre.text.trim(),
        direccion: _direccion.text.trim(),
        telefono: _telefono.text.trim(),
        paginaWeb: _pagina.text.trim(),
      );
      if (widget.id == null) {
        await _service.addUniversity(u);
      } else {
        await _service.updateUniversity(u);
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.id == null
                ? 'Universidad creada'
                : 'Universidad actualizada',
          ),
        ),
      );
      context.go('/universidades');
    } catch (e) {
      if (!mounted) {
        return;
      }
      final msg = e is StateError && e.message == 'Firebase no inicializado'
          ? 'No se pudo guardar: Firebase no está configurado en este proyecto.\n\nPara activar el guardado configure Firebase (google-services.json / GoogleService-Info.plist) o ejecute `flutterfire configure`.'
          : 'Error: $e';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Nueva Universidad' : 'Editar Universidad',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loadingData
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nit,
                          decoration: const InputDecoration(
                            labelText: 'NIT',
                            prefixIcon: Icon(Icons.badge),
                          ),
                          validator: _validateNotEmpty,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nombre,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: Icon(Icons.school),
                          ),
                          validator: _validateNotEmpty,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _direccion,
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          validator: _validateNotEmpty,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefono,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: _validateNotEmpty,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _pagina,
                          decoration: const InputDecoration(
                            labelText: 'Página web',
                            prefixIcon: Icon(Icons.link),
                            helperText: 'Incluya http:// o https://',
                          ),
                          validator: _validateUrl,
                        ),
                        const SizedBox(height: 20),
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                widget.id == null ? 'Crear' : 'Actualizar',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

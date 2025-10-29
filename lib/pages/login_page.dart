import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';

enum _LoginState { idle, loading, success, error }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final AuthService _auth = AuthService();

  _LoginState _state = _LoginState.idle;
  String _error = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _state = _LoginState.loading;
      _error = '';
    });

    try {
      await _auth.login(_emailCtrl.text.trim(), _passCtrl.text);
      if (!mounted) return;
      setState(() => _state = _LoginState.success);
      // Navigate to evidence screen
      context.go('/evidence');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _LoginState.error;
        _error = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00695C), Color(0xFF26A69A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo or decorative image
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/seed/login/400/400',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card with form
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Bienvenido',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.teal[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Inicia sesión para continuar',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Ingrese email'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _passCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                  ),
                                  obscureText: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Ingrese contraseña'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          if (_state == _LoginState.loading)
                            const CircularProgressIndicator(),
                          if (_state != _LoginState.loading)
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    child: const Text('Ingresar'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => context.go('/signup'),
                                    child: const Text('Crear usuario'),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          if (_state == _LoginState.error)
                            Text(
                              _error,
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
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

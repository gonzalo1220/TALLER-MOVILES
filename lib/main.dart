import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taller 1 - Flutter Móvil 230212013 Gonzalo Marín ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _title = "Hola, Flutter";
  String _mensaje =
      "bienvenido a Flutter Móvil 230212013 Gonzalo Marín"; // Nuevo mensaje dinámico

  void _changeTitle() {
    setState(() {
      if (_title == "Hola, Flutter") {
        _title = "¡Gonzalo Marin!";
        _mensaje = "Has cambiado el título a tu nombre.";
      } else {
        _title = "Hola, Flutter";
        _mensaje = "El título volvió al original.";
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Título actualizado")));
  }

  void _mostrarMensaje(String mensaje) {
    setState(() {
      _mensaje = mensaje;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Texto con tu nombre y código
              const Center(
                child: Text(
                  "Gonzalo Marín\n230212013",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Row con imágenes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png",
                    width: 100,
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Image.asset("assets/devour.jpg", width: 100),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botón principal que cambia el título
              ElevatedButton(
                onPressed: _changeTitle,
                child: const Text("Cambiar título"),
              ),
              const SizedBox(height: 20),

              // Más botones con mensajes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        _mostrarMensaje("Hiciste clic en OutlinedButton"),
                    child: const Text("Outlined"),
                  ),
                  TextButton(
                    onPressed: () =>
                        _mostrarMensaje("Hiciste clic en TextButton"),
                    child: const Text("TextButton"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _mostrarMensaje("Hiciste clic en Favorito ⭐"),
                    icon: const Icon(Icons.star),
                    label: const Text("Favorito"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Texto dinámico del mensaje
              Text(
                _mensaje,
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ListView dentro de un contenedor con tamaño fijo
              SizedBox(
                height: 120,
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Perfil"),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Configuración"),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Cerrar sesión"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stack con imagen y texto superpuesto
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    "https://picsum.photos/250?image=9",
                    width: 200,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    "Texto encima",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      "Texto encima",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Imagen grande tipo portada/banner
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    "https://picsum.photos/400/200",
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black54,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: const Text(
                      "Banner con texto final",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } // se realizo todos los cambios respecto al taller 1
}

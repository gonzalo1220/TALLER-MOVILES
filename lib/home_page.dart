import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _title = "Hola, Flutter";
  String _mensaje = "Bienvenido a Flutter Móvil 230212013 Gonzalo Marín";

  late TabController _tabController; // Para el TabBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _changeTitle() {
    setState(() {
      if (_title == "Hola, Flutter") {
        _title = "¡Gonzalo Marín!";
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
      // ✅ Drawer como tercer widget
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menú Lateral",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text("Inicio")),
            ListTile(leading: Icon(Icons.info), title: Text("Acerca de")),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: "GridView"),
            Tab(icon: Icon(Icons.widgets), text: "Otros Widgets"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // ✅ Primer Tab con GridView
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(16),
            children: List.generate(
              6,
              (index) => Card(
                color: Colors.blue[100 * ((index % 8) + 1)],
                child: Center(
                  child: Text(
                    "Item ${index + 1}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),

          // ✅ Segundo Tab con el resto de tus widgets
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Gonzalo Marín\n230212013",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

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
                      child: Image.network(
                        "https://picsum.photos/100",
                        width: 100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _changeTitle,
                  child: const Text("Cambiar título"),
                ),
                const SizedBox(height: 20),

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

                Text(
                  _mensaje,
                  style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                const Text(
                  "Navegación con go_router",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.go('/detail/IrConGo');
                  },
                  child: const Text("Ir con go()"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.push('/detail/IrConPush');
                  },
                  child: const Text("Ir con push()"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.replace('/detail/IrConReplace');
                  },
                  child: const Text("Ir con replace()"),
                ),
                const SizedBox(height: 20),

                // ✅ ListView pequeño
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
        ],
      ),
    );
  }
}

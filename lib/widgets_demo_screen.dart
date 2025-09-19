import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetsDemoScreen extends StatelessWidget {
  const WidgetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Demo Widgets"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_on), text: "Grid"),
              Tab(icon: Icon(Icons.list), text: "Lista"),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "Menú lateral",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(title: const Text("Home"), onTap: () => context.go('/')),
              ListTile(
                title: const Text("Detalle"),
                onTap: () => context.go('/detail'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blue[100 * ((index % 5) + 1)],
                  child: Center(
                    child: Text(
                      "Item ${index + 1}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star),
                  title: Text("Elemento ${index + 1}"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

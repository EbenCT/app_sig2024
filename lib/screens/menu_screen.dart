import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'cuts_list_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Ver Mapa de Cortes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Lista de Cortes Realizados'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CutsListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Salir'),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/user.dart';
import 'import_cuts_screen.dart';
import 'map_screen.dart';
import 'cuts_list_screen.dart';

class MenuScreen extends StatelessWidget {
  final User user;

  MenuScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        automaticallyImplyLeading: false, // Deshabilita el botón de regreso.
      ),
      body: Column(
        children: [
          // Encabezado con información del usuario.
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido, ${user.role}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        'ID Usuario: ${user.userId}',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        'Empresa ID: ${user.companyId}',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
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
                  leading: Icon(Icons.download),
                  title: Text('Importar Cortes desde el Servidor'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImportCutsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Exportar Cortes al Servidor'),
                  onTap: () {
                    _exportCutsToServer(context);
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
          ),
        ],
      ),
    );
  }

  // Función para exportar cortes al servidor.
  void _exportCutsToServer(BuildContext context) async {
    // Aquí puedes implementar la lógica para consumir la API de exportación.
    // Por ahora, mostraré un mensaje de ejemplo.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exportando cortes al servidor...')),
    );

    // Llama a un método del servicio (ApiService) para enviar los datos al servidor.
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'export_cuts_screen.dart';
import 'import_cuts_screen.dart';
import 'map_screen.dart';
import 'cuts_list_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Cargando información del usuario...")),
      );
    }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExportCutsScreen()),
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
          ),
        ],
      ),
    );
  }
}

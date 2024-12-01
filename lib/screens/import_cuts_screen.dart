import 'package:flutter/material.dart';
import '../models/rutas.dart';
import '../services/api_service.dart';

class ImportCutsScreen extends StatefulWidget {
  @override
  _ImportCutsScreenState createState() => _ImportCutsScreenState();
}

class _ImportCutsScreenState extends State<ImportCutsScreen> {
  final ApiService apiService = ApiService();
  List<RouteData> _routes = [];
  RouteData? _selectedRoute;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    try {
      final routes = await apiService.fetchRoutes();
      setState(() {
        _routes = routes;
      });
    } catch (e) {
      print("Error al cargar rutas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar rutas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Importar Cortes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<RouteData>(
              value: _selectedRoute,
              hint: Text("Seleccione una ruta"),
              isExpanded: true,
              items: _routes.map((route) {
                return DropdownMenuItem<RouteData>(
                  value: route,
                  child: Text("${route.dNomb} - ${route.bsrutride}"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoute = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedRoute != null
                  ? () {
                      // Acción al confirmar la selección
                      print("Ruta seleccionada: ${_selectedRoute!.dNomb}");
                    }
                  : null,
              child: Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }
}

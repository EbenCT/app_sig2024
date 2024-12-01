import 'package:flutter/material.dart';
import '../models/cut_point.dart';
import '../models/rutas.dart';
import '../services/api_service.dart';

class ImportCutsScreen extends StatefulWidget {
  @override
  _ImportCutsScreenState createState() => _ImportCutsScreenState();
}

class _ImportCutsScreenState extends State<ImportCutsScreen> {
  final ApiService apiService = ApiService();
  List<RouteData> _routes = [];
  List<CutPoint> _cutPoints = [];
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar rutas")),
      );
    }
  }

  Future<void> _loadCutPoints() async {
    if (_selectedRoute == null) return;
    try {
      final cutPoints = await apiService.fetchCutPoints(
        _selectedRoute!.bsrutnrut,
        0,
        _selectedRoute!.bsrutcper, // Cambia según sea necesario.
      );
      setState(() {
        _cutPoints = cutPoints;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar puntos de corte")),
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
              onPressed: _loadCutPoints,
              child: Text("Confirmar"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _cutPoints.length,
                itemBuilder: (context, index) {
                  final point = _cutPoints[index];
                  return ListTile(
                    title: Text("${point.dNomb}"),
                    subtitle: Text("C.U.: ${point.bscocNcnt}, C.F.: ${point.bscntCodf}"),
                    trailing: Text("Lat: ${point.bscntlati}, Lon: ${point.bscntlogi}"),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para grabar
              },
              child: Text("Grabar"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cut.dart';
import '../models/cut_point.dart';
import '../models/rutas.dart';
import '../providers/cuts_provider.dart';
import '../services/api_service.dart';
import 'map_screen.dart';

class ImportCutsScreen extends StatefulWidget {
  @override
  _ImportCutsScreenState createState() => _ImportCutsScreenState();
}

class _ImportCutsScreenState extends State<ImportCutsScreen> {
  final ApiService apiService = ApiService();
  List<RouteData> _routes = [];
  List<CutPoint> _cutPoints = [];
  RouteData? _selectedRoute;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    try {
      final routes = await apiService.fetchRoutes();
      setState(() {
        // Agrega la opción "TODOS LOS CORTES" al inicio.
        _routes = [
          RouteData(
            bsrutnrut: 1,
            bsrutdesc: "TODOS LOS CORTES",
            bsrutabrv: "",
            bsruttipo: 0,
            bsrutnzon: 0,
            bsrutfcor: "",
            bsrutcper: 0,
            bsrutstat: 0,
            bsrutride: 0,
            dNomb: "TODOS LOS CORTES",
            gbzonNzon: 0,
            dNzon: "",
          ),
          ...routes,
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar rutas")),
      );
    }
  }

  Future<void> _loadCutPoints({RouteData? selectedRoute, String? fixedCode}) async {
    if (selectedRoute == null && fixedCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor seleccione una ruta")),
      );
      return;
    }

    try {
      if (fixedCode != null) {
        // Selecciona automáticamente la ruta basada en el código fijo.
        final matchingRoute = _routes.firstWhere(
          (route) => route.bsrutride.toString() == fixedCode,
          orElse: () => RouteData(
            bsrutnrut: 1,
            bsrutdesc: "TODOS LOS CORTES",
            bsrutabrv: "",
            bsruttipo: 0,
            bsrutnzon: 0,
            bsrutfcor: "",
            bsrutcper: 0,
            bsrutstat: 0,
            bsrutride: 0,
            dNomb: "TODOS LOS CORTES",
            gbzonNzon: 0,
            dNzon: "",
          ),
        );

        setState(() {
          _selectedRoute = matchingRoute;
        });
      }

      final cutPoints = await apiService.fetchCutPoints(
        _selectedRoute?.bsrutnrut ?? 1,
        0,
        _selectedRoute?.bsrutcper ?? 0,
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
            // Lista desplegable
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
            // Campo de texto para el código fijo
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "Ingrese Código Fijo",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // Botón Confirmar
            ElevatedButton(
              onPressed: () {
                final fixedCode = _codeController.text.isNotEmpty
                    ? _codeController.text
                    : null;
                _loadCutPoints(
                  selectedRoute: fixedCode == null ? _selectedRoute : null,
                  fixedCode: fixedCode,
                );
              },
              child: Text("Confirmar"),
            ),
            SizedBox(height: 20),
            // Lista de cortes
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
            // Botón Grabar
            ElevatedButton(
              onPressed: () {
                if (_cutPoints.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No hay puntos de corte para guardar")),
                  );
                  return;
                }

                final cuts = _cutPoints.map((point) => Cut.fromCutPoint(point)).toList();
                Provider.of<CutsProvider>(context, listen: false).setCuts(cuts);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Text("Grabar"),
            ),
          ],
        ),
      ),
    );
  }
}

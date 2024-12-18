import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cut.dart';
import '../models/user.dart';
import '../providers/cuts_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class ExportCutsScreen extends StatefulWidget {
  @override
  _ExportCutsScreenState createState() => _ExportCutsScreenState();
}

class _ExportCutsScreenState extends State<ExportCutsScreen> {
  final ApiService apiService = ApiService();
  Map<int, bool> _selectedCuts = {}; // Estado de selección de cortes

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final cutsProvider = Provider.of<CutsProvider>(context, listen: false);
    final List<Cut> registeredCuts = cutsProvider.cuts.where((cut) => cut.completed).toList();

    if (registeredCuts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Exportar Cortes')),
        body: Center(child: Text("No hay cortes realizados para exportar.")),
      );
    }

    // Inicializa los cortes seleccionados si no están ya configurados.
    if (_selectedCuts.isEmpty) {
      _selectedCuts = {
        for (var cut in registeredCuts) cut.id: false,
      };
    }

    return Scaffold(
      appBar: AppBar(title: Text('Exportar Cortes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: registeredCuts.length,
                itemBuilder: (context, index) {
                  final cut = registeredCuts[index];
                  return CheckboxListTile(
                    title: Text("Corte ID: ${cut.id} - ${cut.name}"),
                    subtitle: Text("Código Fijo: ${cut.fixedCode}"),
                    value: _selectedCuts[cut.id],
                    onChanged: (isSelected) {
                      setState(() {
                        _selectedCuts[cut.id] = isSelected ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: registeredCuts.isEmpty
                  ? null
                  : () async {
                      await _exportSelectedCuts(context, registeredCuts, user!);
                    },
              child: Text("Exportar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: registeredCuts.isEmpty ? Colors.grey : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportSelectedCuts(BuildContext context, List<Cut> cuts, User user) async {
    final selectedCuts = cuts.where((cut) => _selectedCuts[cut.id] == true).toList();

    // Si no hay cortes seleccionados, exportar todos los cortes registrados.
    final cutsToExport = selectedCuts.isNotEmpty ? selectedCuts : cuts;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exportando cortes seleccionados al servidor...")),
    );

    for (final cut in cutsToExport) {
      try {
        final result = await apiService.exportCut(
          liNcoc: cut.id,
          liCemc: user.userId,
          ldFcor: DateTime.now().toIso8601String().split('.')[0],
          liPres: 0,
          liCobc: cut.failed ? 1 : 0,
          liLcor: cut.lectura,
          liNofn: cut.completed ? 1 : 0,
          lsAppName: "AppSIG",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result == 1
                  ? "Corte ID ${cut.id} exportado con éxito."
                  : "Error al exportar corte ID ${cut.id}.",
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al exportar corte ID ${cut.id}: $e")),
        );
      }
    }
  }
}

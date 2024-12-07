import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cuts_provider.dart';
import 'register_cut_screen.dart';

class CutsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cutsProvider = Provider.of<CutsProvider>(context);
    final cuts = cutsProvider.cuts;

    return Scaffold(
      appBar: AppBar(title: Text('Lista de Cortes')),
      body: cuts.isEmpty
          ? Center(child: Text('No hay cortes registrados.'))
          : ListView.builder(
              itemCount: cuts.length,
              itemBuilder: (context, index) {
                final cut = cuts[index];

                return ListTile(
                  title: Text('Cliente: ${cut.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Código Fijo: ${cut.fixedCode}'),
                      Text('Ubicación: ${cut.location}'),
                    ],
                  ),
                  trailing: Icon(
                    cut.completed
                        ? Icons.check_circle
                        : cut.failed
                            ? Icons.error
                            : Icons.pending,
                    color: cut.completed
                        ? Colors.green
                        : cut.failed
                            ? Colors.orange
                            : Colors.grey,
                  ),
                  onTap: () {
                    // Si el corte ya está completado, muestra un mensaje y no permite navegar.
                    if (cut.completed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Este corte ya está completado y no se puede editar.",
                          ),
                        ),
                      );
                      return;
                    }

                    // Navega al formulario de registro de cortes.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterCutScreen(cut: cut),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cuts_provider.dart';

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
                  title: Text('Corte ID: ${cut.id}'),
                  subtitle: Text('Ubicación: ${cut.location}'),
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
                );
              },
            ),
    );
  }
}

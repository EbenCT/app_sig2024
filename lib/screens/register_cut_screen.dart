import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cut.dart';
import '../providers/cuts_provider.dart';

class RegisterCutScreen extends StatefulWidget {
  final Cut cut;

  RegisterCutScreen({required this.cut});

  @override
  _RegisterCutScreenState createState() => _RegisterCutScreenState();
}

class _RegisterCutScreenState extends State<RegisterCutScreen> {
  final _readingController = TextEditingController();
  String? _observation;

  void _saveCut() {
    final cutsProvider = Provider.of<CutsProvider>(context, listen: false);
/*
    if (_readingController.text.isNotEmpty) {
      final updatedCut = Cut(
        id: widget.cut.id,
        location: widget.cut.location,
        completed: true,
      );
      cutsProvider.updateCut(updatedCut);
    } else if (_observation != null) {
      final updatedCut = Cut(
        id: widget.cut.id,
        location: widget.cut.location,
        failed: true,
      );
      cutsProvider.updateCut(updatedCut);
    }*/

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Corte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Ubicación: ${widget.cut.location}'),
            TextField(
              controller: _readingController,
              decoration: InputDecoration(labelText: 'Lectura del Medidor'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _observation,
              hint: Text('Seleccione una observación'),
              onChanged: (value) {
                setState(() {
                  _observation = value;
                });
              },
              items: ['No Acceso', 'Medidor Dañado', 'Otro']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCut,
              child: Text('Grabar Corte'),
            ),
          ],
        ),
      ),
    );
  }
}

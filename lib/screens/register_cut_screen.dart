import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cut.dart';
import 'menu_screen.dart';

class RegisterCutScreen extends StatefulWidget {
  final Cut cut;

  RegisterCutScreen({required this.cut});

  @override
  _RegisterCutScreenState createState() => _RegisterCutScreenState();
}

class _RegisterCutScreenState extends State<RegisterCutScreen> {
  final TextEditingController _meterReadingController = TextEditingController();
  String? _selectedObservation;

  final List<String> _observations = [
    "No se pudo cortar",
    "No se pudo lecturar",
    "Dificultades con el cliente",
  ];

  @override
  void initState() {
    super.initState();

    if (widget.cut.completed) {
      _meterReadingController.text = "Completado";
    } else if (widget.cut.failed) {
      _selectedObservation = widget.cut.observation;
    }
  }

  void _saveCut() {
    if (_selectedObservation == null && _meterReadingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor registre la lectura o seleccione una observación.")),
      );
      return;
    }

    setState(() {
      if (_selectedObservation == null) {
        widget.cut.completed = true;
        widget.cut.failed = false;
        widget.cut.lectura = int.parse(_meterReadingController.text);
      } else {
        widget.cut.failed = true;
        widget.cut.completed = false;
        widget.cut.observation = _selectedObservation!;
      }
    });

    Navigator.pop(context, {
      'cutId': widget.cut.id,
      'status': widget.cut.completed ? 'completed' : 'observed',
      'observation': _selectedObservation,
      'meterReading': _meterReadingController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.cut.completed;

    return Scaffold(
      appBar: AppBar(title: Text("Registrar Corte")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Datos del punto de corte:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text("Cliente: ${widget.cut.name}"),
            Text("Dirección: ${widget.cut.location}"),
            Text("ID: ${widget.cut.id}"),
            Text("Código Ubicación: ${widget.cut.ubicCode}"),
            Text("Código Fijo: ${widget.cut.fixedCode}"),
            Text("Medidor Serie: ${widget.cut.meterSerial}"),
            Text("Medidor Número: ${widget.cut.meterNumber}"),
            SizedBox(height: 20),
              TextField(
              controller: _meterReadingController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                // Solo números permitidos.
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: "Lectura del Medidor",
                border: OutlineInputBorder(),
              ),
              enabled: !isReadOnly,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedObservation,
              onChanged: isReadOnly
                  ? null
                  : (value) {
                      setState(() {
                        _selectedObservation = value;
                      });
                    },
              items: _observations.map((observation) {
                return DropdownMenuItem<String>(
                  value: observation,
                  child: Text(observation),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Observación (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            if (!isReadOnly)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Grabar Corte"),
                ),
              ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Ir al plano"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuScreen(), // Asegúrate de que `user` esté definido.
                      ),
                    );
                  },
                  child: Text("Volver al menú"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

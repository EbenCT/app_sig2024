import 'cut_point.dart';

class Cut {
  final int id;
  final String location;
  final String name;
  final int fixedCode;
  final double latitude;
  final double longitude;
  final int ubicCode; // Código de Ubicación
  final String meterSerial; // Medidor serie
  final String meterNumber; // Número del medidor
  bool completed;
  bool failed;
  String observation;
  int lectura;

  Cut({
    required this.id,
    required this.location,
    required this.name,
    required this.fixedCode,
    required this.latitude,
    required this.longitude,
    required this.ubicCode,
    required this.meterSerial,
    required this.meterNumber,
    this.completed = false,
    this.failed = false,
    this.observation = "",
    this.lectura=0,
  });

  factory Cut.fromCutPoint(CutPoint point) {
    return Cut(
      id: point.bscocNcoc,
      location: "${point.bscntlati},${point.bscntlogi}",
      name: point.dNomb,
      fixedCode: point.bscntCodf,
      latitude: point.bscntlati,
      longitude: point.bscntlogi,
      ubicCode: point.bscocNcoc,
      meterSerial: point.bsmednser,
      meterNumber: point.bsmedNume,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'name': name,
      'fixedCode': fixedCode,
      'latitude': latitude,
      'longitude': longitude,
      'ubicCode': ubicCode,
      'meterSerial': meterSerial,
      'meterNumber': meterNumber,
      'completed': completed,
      'failed': failed,
      'observation': observation,
      'lectura': lectura
    };
  }
}

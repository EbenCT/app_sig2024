import 'cut_point.dart';

class Cut {
  final int id;
  final String location;
  final String name;
  final int fixedCode;
  final double latitude;
  final double longitude;
  final bool completed;
  final bool failed;

  Cut({
    required this.id,
    required this.location,
    required this.name,
    required this.fixedCode,
    required this.latitude,
    required this.longitude,
    this.completed = false,
    this.failed = false,
  });

  factory Cut.fromCutPoint(CutPoint point) {
    return Cut(
      id: point.bscocNcnt,
      location: "${point.bscntlati},${point.bscntlogi}",
      name: point.dNomb,
      fixedCode: point.bscntCodf,
      latitude: point.bscntlati,
      longitude: point.bscntlogi,
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
      'completed': completed,
      'failed': failed,
    };
  }
}

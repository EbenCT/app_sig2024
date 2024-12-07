import 'package:app_sig/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cut.dart';
import 'package:provider/provider.dart';
import '../providers/cuts_provider.dart';
import '../utils/map_utils.dart';
import 'dart:math' as math;

import 'menu_screen.dart';
import 'register_cut_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _startingPoint = LatLng(-16.37953779367184, -60.960705279425646);
  String _totalDistance = '';
  String _totalTime = '';
  int _totalCuts = 0;
  int _completedCuts = 0;

  @override
  void initState() {
    super.initState();
    _loadCuts();
    _addCompanyMarker();  
  }

Future<void> _loadCuts() async {
  final cutsProvider = Provider.of<CutsProvider>(context, listen: false);
  final cuts = cutsProvider.cuts;

  if (cuts.isEmpty) return;

  // Ordenar los puntos según la proximidad
  List<Cut> orderedCuts = _orderCutsByProximity(_startingPoint, cuts);

  for (int i = 0; i < orderedCuts.length; i++) {
    final cut = orderedCuts[i];

    // Determinar el color del marcador según el estado actual del corte
    Color markerColor = Colors.red; // Por defecto
    if (cut.completed) {
      markerColor = Colors.green; // Cortado
    } else if (cut.failed) {
      markerColor = Colors.orange; // Con observación
    }

    final markerIcon = await MapUtils.createCustomMarkerWithNumber(i + 1, markerColor);

    _markers.add(
      Marker(
        markerId: MarkerId(cut.id.toString()),
        position: LatLng(cut.latitude, cut.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: "${i + 1}. ${cut.name}",
          snippet: cut.completed
              ? "Estado: Cortado"
              : cut.failed
                  ? "Estado: Con Observación"
                  : "Estado: Pendiente",
        ),
        onTap: () => _onMarkerTap(cut),
      ),
    );
  }
    // Calcular los contadores de cortes
  setState(() {
      _totalCuts = cuts.length;
      _completedCuts = cuts.where((cut) => cut.completed).length;
  });
  // Calcular la ruta óptima
  await _calculateOptimalRoute(orderedCuts);
  setState(() {});
}



Future<void> _calculateOptimalRoute(List<Cut> cuts) async {
  const int maxWaypoints = 23; // Limite de Google Directions (25 - 2)
  LatLng startingPoint = _startingPoint;

  // Divide los puntos en grupos de 23
  List<List<Cut>> groups = [];
  for (int i = 0; i < cuts.length; i += maxWaypoints) {
    groups.add(cuts.sublist(
      i,
      i + maxWaypoints > cuts.length ? cuts.length : i + maxWaypoints,
    ));
  }

  // Procesar cada grupo de forma individual
  List<LatLng> fullRoute = [];
  String origin = "${startingPoint.latitude},${startingPoint.longitude}";

  List<dynamic> allLegs = [];

  for (int i = 0; i < groups.length; i++) {
    String waypoints = groups[i]
        .map((cut) => "${cut.latitude},${cut.longitude}")
        .join('|');
    String destination = (i < groups.length - 1)
        ? "${groups[i + 1].first.latitude},${groups[i + 1].first.longitude}"
        : "${cuts.last.latitude},${cuts.last.longitude}";

    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=optimize:true|$waypoints&key=$ApiKeyGoogle");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;

      if (routes.isNotEmpty) {
        final overviewPolyline = routes.first['overview_polyline']['points'];
        final legs = routes.first['legs'] as List;
        fullRoute.addAll(_decodePolyline(overviewPolyline));
        allLegs.addAll(legs); // Agregar legs de este grupo
        origin = destination; // La última coordenada es el origen del siguiente grupo
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al calcular la subruta")),
      );
      return;
    }
  }

  // Crear la polilínea completa
  setState(() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId('optimal_route'),
        points: fullRoute,
        color: Colors.blue,
        width: 5,
      ),
    );
  });

  // Calcular la distancia y tiempo totales
  await _calculateTotalDistanceAndTime(allLegs, cuts.length);
}

Future<void> _calculateTotalDistanceAndTime(List<dynamic> legs, int numCuts) async {
  const int additionalTimePerCut = 600; // 10 minutos por corte en segundos
  int totalDistance = 0; // En metros
  int totalDuration = 0; // En segundos

  for (final leg in legs) {
    totalDistance += (leg['distance']['value'] as num).toInt(); // En metros
    totalDuration += (leg['duration']['value'] as num).toInt(); // En segundos
  }

  // Agregar 10 minutos por cada corte
  totalDuration += numCuts * additionalTimePerCut;

  // Formatear el tiempo total en días, horas y minutos
  final int days = totalDuration ~/ 86400; // Un día tiene 86400 segundos
  final int hours = (totalDuration % 86400) ~/ 3600; // Una hora tiene 3600 segundos
  final int minutes = (totalDuration % 3600) ~/ 60; // Un minuto tiene 60 segundos

  String formattedTime = "";
  if (days > 0) {
    formattedTime += "$days día${days > 1 ? 's' : ''}, ";
  }
  if (hours > 0 || days > 0) {
    formattedTime += "$hours hora${hours > 1 ? 's' : ''}, ";
  }
  formattedTime += "$minutes minuto${minutes > 1 ? 's' : ''}";

  setState(() {
    _totalDistance = "${(totalDistance / 1000).toStringAsFixed(2)} km"; // Convertir metros a kilómetros
    _totalTime = formattedTime;
  });
}



  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  List<Cut> _orderCutsByProximity(LatLng startPoint, List<Cut> cuts) {
  List<Cut> orderedCuts = [];
  LatLng currentPoint = startPoint;

  // Crear una copia de la lista para trabajar sin modificar el original
  List<Cut> remainingCuts = List.from(cuts);

  while (remainingCuts.isNotEmpty) {
    // Encontrar el punto más cercano al actual
    Cut closestCut = remainingCuts.reduce((a, b) {
      double distanceA = _calculateDistance(currentPoint, LatLng(a.latitude, a.longitude));
      double distanceB = _calculateDistance(currentPoint, LatLng(b.latitude, b.longitude));
      return distanceA < distanceB ? a : b;
    });

    // Añadir el más cercano a la lista ordenada
    orderedCuts.add(closestCut);

    // Actualizar el punto actual y eliminar el seleccionado de la lista restante
    currentPoint = LatLng(closestCut.latitude, closestCut.longitude);
    remainingCuts.remove(closestCut);
  }

  return orderedCuts;
}

double _calculateDistance(LatLng a, LatLng b) {
  const double R = 6371e3; // Radio de la Tierra en metros
  double phi1 = a.latitude * (math.pi / 180); // Radianes
  double phi2 = b.latitude * (math.pi / 180);
  double deltaPhi = (b.latitude - a.latitude) * (math.pi / 180);
  double deltaLambda = (b.longitude - a.longitude) * (math.pi / 180);

  double haversine = 
      math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
      math.cos(phi1) * math.cos(phi2) *
      math.sin(deltaLambda / 2) * math.sin(deltaLambda / 2);

  double c = 2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));

  return R * c; // Distancia en metros
}
  // Función para añadir el marcador de la empresa
  Future<void> _addCompanyMarker() async {
    final companyMarkerIcon = await MapUtils.createCompanyMarker();
    _markers.add(
      Marker(
        markerId: MarkerId('company'),
        position: _startingPoint,
        icon: companyMarkerIcon,
        infoWindow: InfoWindow(title: 'COOSIV RL'),
      ),
    );
    setState(() {});
  }

  void _onMarkerTap(Cut cut) async {

  if (cut.completed) {
    // Mostrar mensaje si el corte ya está completado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Este corte ya está completado y no se puede editar.")),
    );
    return;
  }

  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegisterCutScreen(cut: cut)),
  );

  if (result != null) {
    final status = result['status'];
    final observation = result['observation'];

    // Actualizar el marcador en el mapa
    final newColor = status == 'completed' ? Colors.green : Colors.orange;
    final markerIcon = await MapUtils.createCustomMarkerWithNumber(cut.id, newColor);

    _markers.removeWhere((marker) => marker.markerId.value == cut.id.toString());
    _markers.add(
      Marker(
        markerId: MarkerId(cut.id.toString()),
        position: LatLng(cut.latitude, cut.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: cut.name,
          snippet: status == 'completed' ? "Corte completado" : observation,
        ),
        onTap: () => _onMarkerTap(cut),
      ),
    );

    setState(() {});
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Mapa de Cortes'),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuScreen(), // Asegúrate de que `user` esté definido.
              ),
            );
          },
        ),
      ],
    ),
      body: Column(
        children: [
          // Mapa
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
              },
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: _startingPoint,
                zoom: 14,
              ),
            ),
          ),
          // Información de distancia y tiempo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Distancia Total: $_totalDistance"),
                Text("Tiempo Total: $_totalTime"),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Cortes por Realizar: ${_totalCuts - _completedCuts}"),
                    Text("Cortes Registrados: $_completedCuts"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



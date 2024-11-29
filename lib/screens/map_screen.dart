import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/cuts_provider.dart';
import '../models/cut.dart';
import 'register_cut_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _loadCuts();
  }

  void _loadCuts() {
    final cutsProvider = Provider.of<CutsProvider>(context, listen: false);
    final cuts = cutsProvider.cuts;

    for (var cut in cuts) {
      _markers.add(
        Marker(
          markerId: MarkerId(cut.id.toString()),
          position: LatLng(double.parse(cut.location.split(',')[0]),
              double.parse(cut.location.split(',')[1])),
          onTap: () {
            _registerCut(cut);
          },
        ),
      );
    }
  }

  void _registerCut(Cut cut) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterCutScreen(cut: cut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Cortes')),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        markers: _markers,
        polylines: _polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(-17.7833, -63.1833), // Ejemplo: Coordenadas iniciales.
          zoom: 14,
        ),
      ),
    );
  }
}

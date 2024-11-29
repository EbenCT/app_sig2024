import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Polyline getOptimalRoute(List<LatLng> points) {
    return Polyline(
      polylineId: PolylineId('optimal_route'),
      points: points,
      color: Colors.blue,
      width: 4,
    );
  }

  static Marker createMarker({
    required String id,
    required LatLng position,
    required String title,
    required Function() onTap,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: title),
      onTap: onTap,
    );
  }
}

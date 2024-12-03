import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Future<BitmapDescriptor> createCustomMarkerWithNumber(int number, Color color) async {
    final PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = color;

    // Tamaño del círculo y del texto
    const double size = 80.0;
    const double textSize = 30.0;

    // Dibuja el círculo
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);

    // Dibuja el número en el centro
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          fontSize: textSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final img = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}

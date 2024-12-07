import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

// Crear marcador personalizado para la empresa con redimensionamiento
  static Future<BitmapDescriptor> createCompanyMarker() async {
    // Cargar la imagen del logo desde los assets
    final ByteData data = await rootBundle.load('assets/logo-coosivrl.png');
    final Uint8List bytes = data.buffer.asUint8List();  // Usa Uint8List aquí
    
    // Decodificar la imagen
    final image = await decodeImageFromList(bytes);
    
    // Redimensionar la imagen
    final resizedImage = await _resizeImage(image, 100, 100);  // Ajusta el tamaño aquí

    final img = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    
    // Convertir la imagen redimensionada a BitmapDescriptor
    return BitmapDescriptor.fromBytes(Uint8List.fromList(img!.buffer.asUint8List()));
  }

  // Función para redimensionar la imagen
  static Future<ui.Image> _resizeImage(ui.Image image, int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(width.toDouble(), height.toDouble())));
    final paint = Paint();
    canvas.drawImageRect(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);
    final picture = recorder.endRecording();
    final resizedImage = await picture.toImage(width, height);
    return resizedImage;
  }
}

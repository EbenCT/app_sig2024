import 'dart:convert';
import 'package:app_sig/utils/variables.dart';
import 'package:http/http.dart' as http;

import '../models/cut.dart';

class ApiService {
  final String baseUrl = Api;

   Future<Map<String, dynamic>> login(String username, String password) async {
    print("usuario: $username, contraseña: $password");
    final String soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ValidarLoginPassword xmlns="http://tempuri.org/">
      <lsLogin>$username</lsLogin>
      <lsPassword>$password</lsPassword>
    </ValidarLoginPassword>
  </soap:Body>
</soap:Envelope>
''';

    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '"http://tempuri.org/ValidarLoginPassword"',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/wsAD.asmx'),
      headers: headers,
      body: soapEnvelope,
    );
    print("statusCode: ${response.statusCode}");
  print("response: ${response.body}");
    if (response.statusCode == 200) {
      final responseBody = response.body;
      return _parseLoginResponse(responseBody);
    } else {
      throw Exception("Error al iniciar sesión: ${response.statusCode}");
    }
  }

  /// Parsear la respuesta SOAP del login
  Map<String, dynamic> _parseLoginResponse(String responseBody) {
    // Extraer solo el contenido de <ValidarLoginPasswordResult>...</ValidarLoginPasswordResult>
    final regex = RegExp(r'<ValidarLoginPasswordResult>(.*?)<\/ValidarLoginPasswordResult>');
    final match = regex.firstMatch(responseBody);

    if (match != null) {
      final result = match.group(1)!; // Ejemplo: "OK|Registra Cortes WEB|152|6272"
      final parts = result.split('|');
      return {
        'status': parts[0], // OK
        'role': parts[1],   // Registra Cortes WEB
        'userId': parts[2], // 152
        'companyId': parts[3], // 6272
      };
    } else {
      throw Exception("Respuesta de login inválida");
    }
  }

  Future<List<dynamic>> getCuts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cuts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener cortes");
    }
  }

  Future<void> registerCut(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register_cut'),
      headers: {'Authorization': 'Bearer $token'},
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al registrar el corte");
    }
  }
  Future<void> exportCuts(String token, List<Cut> cuts) async {
  final response = await http.post(
    Uri.parse('$baseUrl/export_cuts'),
    headers: {'Authorization': 'Bearer $token'},
    body: json.encode({'cuts': cuts.map((e) => e.toJson()).toList()}),
  );

  if (response.statusCode != 200) {
    throw Exception("Error al exportar cortes");
  }
}

}

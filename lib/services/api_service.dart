import 'dart:convert';
import 'package:app_sig/utils/variables.dart';
import 'package:http/http.dart' as http;

import '../models/cut.dart';

class ApiService {
  final String baseUrl = Api;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wsGB.asmx'),
      body: {'username': username, 'password': password},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al iniciar sesión");
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

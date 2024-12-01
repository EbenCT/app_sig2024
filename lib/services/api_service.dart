import 'dart:convert';
import 'package:app_sig/utils/variables.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/cut.dart';
import '../models/cut_point.dart';
import '../models/rutas.dart';

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

  Future<List<RouteData>> fetchRoutes() async {
    final String soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W0Corte_ObtenerRutas xmlns="http://activebs.net/">
      <liCper>0</liCper>
    </W0Corte_ObtenerRutas>
  </soap:Body>
</soap:Envelope>
''';

    final headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': '"http://activebs.net/W0Corte_ObtenerRutas"',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/wsBS.asmx'),
      headers: headers,
      body: soapEnvelope,
    );

    if (response.statusCode == 200) {
      final xmlResponse = XmlDocument.parse(response.body);
      final List<RouteData> routes = [];

      // Extraer datos de cada tabla
      for (final table in xmlResponse.findAllElements('Table')) {
        final routeData = RouteData.fromXml({
          'bsrutnrut': table.findElements('bsrutnrut').first.text,
          'bsrutdesc': table.findElements('bsrutdesc').first.text,
          'bsrutabrv': table.findElements('bsrutabrv').first.text,
          'bsruttipo': table.findElements('bsruttipo').first.text,
          'bsrutnzon': table.findElements('bsrutnzon').first.text,
          'bsrutfcor': table.findElements('bsrutfcor').first.text,
          'bsrutcper': table.findElements('bsrutcper').first.text,
          'bsrutstat': table.findElements('bsrutstat').first.text,
          'bsrutride': table.findElements('bsrutride').first.text,
          'dNomb': table.findElements('dNomb').first.text,
          'GbzonNzon': table.findElements('GbzonNzon').first.text,
          'dNzon': table.findElements('dNzon').first.text,
        });
        routes.add(routeData);
      }

      return routes;
    } else {
      throw Exception("Error al obtener las rutas: ${response.statusCode}");
    }
  }

  Future<List<CutPoint>> fetchCutPoints(int liNrut, int liNcnt, int liCper) async {
  final String soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W2Corte_ReporteParaCortesSIG xmlns="http://activebs.net/">
      <liNrut>$liNrut</liNrut>
      <liNcnt>$liNcnt</liNcnt>
      <liCper>$liCper</liCper>
    </W2Corte_ReporteParaCortesSIG>
  </soap:Body>
</soap:Envelope>
''';

  final headers = {
    'Content-Type': 'text/xml; charset=utf-8',
    'SOAPAction': '"http://activebs.net/W2Corte_ReporteParaCortesSIG"',
  };

  final response = await http.post(
    Uri.parse('$baseUrl/wsBS.asmx'),
    headers: headers,
    body: soapEnvelope,
  );
  print("respuesta api cortes:");
  print(response.body);
  if (response.statusCode == 200) {
    final xmlResponse = XmlDocument.parse(response.body);
    final List<CutPoint> cutPoints = [];

    for (final table in xmlResponse.findAllElements('Table')) {
      final cutPoint = CutPoint.fromXml({
        'bscocNcoc': table.findElements('bscocNcoc').first.text,
        'bscntCodf': table.findElements('bscntCodf').first.text,
        'bscocNcnt': table.findElements('bscocNcnt').first.text,
        'dNomb': table.findElements('dNomb').first.text,
        'bscocNmor': table.findElements('bscocNmor').first.text,
        'bscocImor': table.findElements('bscocImor').first.text,
        'bsmednser': table.findElements('bsmednser').first.text,
        'bsmedNume': table.findElements('bsmedNume').first.text,
        'bscntlati': table.findElements('bscntlati').first.text,
        'bscntlogi': table.findElements('bscntlogi').first.text,
        'dNcat': table.findElements('dNcat').first.text,
        'dCobc': table.findElements('dCobc').first.text,
        'dLotes': table.findElements('dLotes').first.text,
      });
      cutPoints.add(cutPoint);
    }

    return cutPoints;
  } else {
    throw Exception("Error al obtener puntos de corte: ${response.statusCode}");
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

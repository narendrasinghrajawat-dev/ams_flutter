import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';



class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = ApiEndpoints.baseUrl});

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json', ...?headers});
    return _processResponse(resp);
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final resp = await http.get(uri, headers: {...?headers});
    return _processResponse(resp);
  }

  Map<String, dynamic> _processResponse(http.Response resp) {
    final code = resp.statusCode;
    final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
    if (code >= 200 && code < 300) {
      return {'status': true, 'data': body};
    } else {
      return {'status': false, 'message': body.toString(), 'code': code};
    }
  }
}

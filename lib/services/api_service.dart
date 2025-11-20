// lib/services/api_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/storage_service.dart';
import '../core/constants/const_strings.dart';

class ApiService {
  final StorageService _storage = StorageService();

  final String baseUrl = dotenv.env['baseURL'] ?? '';

  final Duration timeout = const Duration(seconds: 15);

  // -----------------------------
  // COMMON HEADERS
  // -----------------------------
  Map<String, String> _headers({String acceptLanguage = "en"}) {
    final token = _storage.readString(AppStrings.token);

    return {
      "Content-Type": "application/json",
      "Accept-Language": acceptLanguage,
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"
    };
  }

  // -----------------------------
  // GET METHOD
  // -----------------------------
  Future<dynamic> get(String path) async {
    final url = Uri.parse("$baseUrl$path");

    try {
      final response = await http.get(url, headers: _headers()).timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET error: $e");
    }
  }

  // -----------------------------
  // POST METHOD
  // -----------------------------
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$path");
   print('post url is teh $url');
   print(_headers());


    try {
      final response = await http
          .post(url, headers: _headers(), body: jsonEncode(body))
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("POST error: $e");
    }
  }

  // -----------------------------
  // PUT METHOD
  // -----------------------------
  Future<dynamic> update(String path, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$path");

    print('update start is teh $url');
    print(body);

    try {
      final response = await http
          .patch(url, headers: _headers(), body: jsonEncode(body))
          .timeout(timeout);

      print('update resaponse iteh $response');
      print(response.statusCode);
      print(response.body);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("PUT error: $e");
    }
  }

  // -----------------------------
  // DELETE METHOD
  // -----------------------------
  Future<dynamic> delete(String path) async {
    final url = Uri.parse("$baseUrl$path");

    try {
      final response =
      await http.delete(url, headers: _headers()).timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception("DELETE error: $e");
    }
  }

  // -----------------------------
  // HANDLE API RESPONSE
  // -----------------------------
  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;

    // decode body
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (status == 200 || status == 201) {
      return body?['data'] ?? body;
    }

    if (status == 400) throw Exception(body?['message'] ?? "Bad Request");
    if (status == 401) throw Exception("Unauthorized");
    if (status == 403) throw Exception("Forbidden");
    if (status == 404) throw Exception("Not Found");
    if (status == 500) throw Exception("Server Error");

    throw Exception("Error ${response.statusCode}: ${response.body}");
  }
}

// lib/services/api_service.dart
import 'dart:convert';
import 'dart:async';

import 'package:attedance_management_system/services/common/storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/loading_controller.dart';
import '../../core/constants/const_strings.dart';

class ApiService {
  final StorageService _storage = StorageService();

  final String baseUrl = dotenv.env['baseURL'] ?? '';

  final Duration timeout = const Duration(seconds: 15);

  // Get global LoadingController
  LoadingController get _loader => Get.find<LoadingController>();

  // -----------------------------
  // COMMON HEADERS
  // -----------------------------
  Map<String, String> _headers({String acceptLanguage = "en"}) {
    final token = _storage.readString(AppStrings.token);

    return {
      "Content-Type": "application/json",
      "Accept-Language": acceptLanguage,
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // -----------------------------
  // INTERNAL WRAPPER (loader + timeout)
  // -----------------------------
  Future<dynamic> _sendRequest(
      Future<http.Response> Function() requestFn, {
        bool showLoader = true,
      }) async {
    if (showLoader) _loader.start();

    try {
      final response = await requestFn().timeout(timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception("Request timed out");
    } catch (e) {
      // you can log e here if you want
      throw Exception("Network error: $e");
    } finally {
      if (showLoader) _loader.stop();
    }
  }

  // -----------------------------
  // GET METHOD
  // -----------------------------
  Future<dynamic> get(String path, {bool showLoader = true}) async {
    final url = Uri.parse("$baseUrl$path");

    print('GET start:');
    print(path);
    print(url);

    return _sendRequest(
          () => http.get(url, headers: _headers()),
      showLoader: showLoader,
    );
  }

  // -----------------------------
  // POST METHOD
  // -----------------------------
  Future<dynamic> post(String path, Map<String, dynamic> body,
      {bool showLoader = true}) async {
    final url = Uri.parse("$baseUrl$path");

    print('POST url: $url');
    print(_headers());
    print('body: ${jsonEncode(body)}');

    return _sendRequest(
          () => http.post(url, headers: _headers(), body: jsonEncode(body)),
      showLoader: showLoader,
    );
  }

  // -----------------------------
  // UPDATE (PATCH) METHOD
  // -----------------------------
  Future<dynamic> update(String path, Map<String, dynamic> body,
      {bool showLoader = true}) async {
    final url = Uri.parse("$baseUrl$path");

    print('UPDATE start: $url');
    print(body);

    return _sendRequest(
          () => http.patch(url, headers: _headers(), body: jsonEncode(body)),
      showLoader: showLoader,
    );
  }

  // -----------------------------
  // DELETE METHOD
  // -----------------------------
  Future<dynamic> delete(String path, {bool showLoader = true}) async {
    final url = Uri.parse("$baseUrl$path");

    print('DELETE start: $url');

    return _sendRequest(
          () => http.delete(url, headers: _headers()),
      showLoader: showLoader,
    );
  }

  // -----------------------------
  // HANDLE API RESPONSE
  // -----------------------------
  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;

    print('API response status: $status');
    print('API response body: ${response.body}');

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

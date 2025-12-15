// lib/services/api_service.dart
import 'dart:convert';
import 'dart:async';

import 'package:attedance_management_system/modules/common/services/storage_service.dart';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/const_strings.dart';
import '../controller/loading_controller.dart';
import '../helper/api_response_helper.dart';

class ApiService {
  final StorageService _storage = StorageService();

  final String baseUrl = dotenv.env['baseURL'] ?? '';

  final Duration timeout = const Duration(seconds: 15);

  // track concurrent requests (extra safety, though controller also tracks)
  int _pendingRequests = 0;

  // Safe access to LoadingController
  LoadingController? get _loaderOrNull =>
      Get.isRegistered<LoadingController>() ? Get.find<LoadingController>() : null;

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
    final loader = _loaderOrNull;

    if (showLoader && loader != null) {
      // loader.show();
    }


    try {
      final response = await requestFn().timeout(timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception("Request timed out");
    } catch (e) {
      throw Exception("Network error: $e");
    } finally {
      if (showLoader && loader != null) {
        // loader.hide();
      }
    }
  }

  // -----------------------------
  // GET METHOD
  // -----------------------------
  Future<dynamic> get(String path, {bool showLoader = true}) async {
    final url = Uri.parse("$baseUrl$path");
    print('GET start: $url');

    return _sendRequest(
          () => http.get(url, headers: _headers()),
      showLoader: showLoader,
    );
  }

  // -----------------------------
  // POST METHOD
  // -----------------------------
  Future<dynamic> post(
      String path,
      Map<String, dynamic> body, {
        bool showLoader = true,
      }) async {
    final url = Uri.parse("$baseUrl$path");
    print('POST url: $url');
    print(_headers());
    print('body: ${jsonEncode(body)}');

    return _sendRequest(
          () => http.post(url, headers: _headers(), body: jsonEncode(body)),
      showLoader: showLoader,
    );
  }

  Future<dynamic> postWithoutHeaders(
      String path,
      Map<String, dynamic> body, {
        bool showLoader = true,
      }) async {
    final url = Uri.parse("$baseUrl$path");

    print('POST (no headers) url: $url');
    print('body: ${jsonEncode(body)}');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept-Language": "en",
    };

    return _sendRequest(
          () => http.post(url, headers: headers, body: jsonEncode(body)),
      showLoader: showLoader,
    );
  }

  // -----------------------------
  // UPDATE (PATCH) METHOD
  // -----------------------------
  Future<dynamic> update(
      String path,
      Map<String, dynamic> body, {
        bool showLoader = true,
      }) async {
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
  Future<dynamic> delete(
      String path, {
        bool showLoader = true,
      }) async {
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

    final body =
    response.body.isNotEmpty ? jsonDecode(response.body) : null;

    // ✅ SUCCESS
    if (status == 200 || status == 201) {
      return body?['data'] ?? body;
    }

    // ❌ ERROR HANDLING
    ApiResponseHelper.showSnackbarByStatus(
      status: status,
      message: body?['message'],

    );

    switch (status) {
      case 400:
        throw Exception(body?['message'] ?? 'Bad Request');

      case 401:
        throw Exception('Unauthorized');

      case 403:
        throw Exception('Forbidden');

      case 404:
        throw Exception('Not Found');

      case 500:
        throw Exception('Server Error');

      default:
        throw Exception(
          'Error $status: ${response.body}',
        );
    }
  }

}

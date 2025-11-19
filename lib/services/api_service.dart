import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';



class ApiService {

  String baseUrl = "${dotenv.env['baseURL']}";
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyNDI1MDIxMjM4OSIsInJvbGUiOiJhZG1pbiIsImVtYWlsIjoibnNyQGdtYWlsLmNvbSIsImlhdCI6MTc2MzU0NzM1MCwiZXhwIjoxNzYzNTgzMzUwfQ.gRiEPYxmzROUEnxTdRFWZJleNyUCsjwQSE3KjX1nFhU";


  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body,{String acceptLanguage = 'en'}) async {
    final uri = Uri.parse('$baseUrl$path');

    // Define headers including the Accept-Language header
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': acceptLanguage,
      "Authorization": "Bearer $token"
    };


    final resp = await http.post(uri, body: jsonEncode(body), headers: headers);

    print('post response is the ');
    print(resp.statusCode);
    print(resp.body);

    return _processResponse(resp);
  }

  Future<dynamic> get(String path,{String acceptLanguage = 'en'}) async {

    print('get start isteh ');
    print(path);

    final uri = Uri.parse('$baseUrl$path');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': acceptLanguage,
      "Authorization": "Bearer $token"
    };



    final resp = await http.get(uri, headers: headers);

    print('get res is teh ');
    print(resp.statusCode);
    print(resp.body);


    return _processResponse(resp);
  }

  dynamic _processResponse( http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body)["data"];
        return responseJson;
      case 201:
        var responseJson = jsonDecode(response.body)["data"];
        return responseJson;
      // case 400:
      //   hideLoadingDialog(context);
      //   showToast(context, apiErrorMessage);
      //   throw BadRequestException(response.body.toString());
      // case 401:
      //   hideLoadingDialog(context);
      //   showToast(context, jsonDecode(response.body)["responseMessage"]);
      //   throw UnauthorisedException(jsonDecode(response.body)["responseMessage"]);
      // case 403:
      //   hideLoadingDialog(context);
      //   showToast(context, apiErrorMessage);
      //   throw UnauthorisedException(response.body.toString());
      // case 404:
      //   hideLoadingDialog(context);
      //   showToast(context, jsonDecode(response.body)["responseMessage"]);
      //   break;
      // case 500:
      //   hideLoadingDialog(context);
      //   showToast(context, jsonDecode(response.body)["errorMessage"]);
      //   break;
      // case 501:
      //   hideLoadingDialog(context);
      //   showToast(context, jsonDecode(response.body)["responseMessage"]);
      //   break;
      default:
        throw 'Error occured while Communication with Server with StatusCode : ${response.statusCode}';
    }
  }


  // Map<String, dynamic> _processResponse(http.Response resp) {
  //   final code = resp.statusCode;
  //   final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
  //   if (code >= 200 && code < 300) {
  //     return {'status': true, 'data': body};
  //   } else {
  //     return {'status': false, 'message': body.toString(), 'code': code};
  //   }
  // }
}

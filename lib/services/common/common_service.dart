

import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:http/http.dart' as _api;

import 'api_service.dart';

class CommonService{


  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> fetchMasterData() async {
    print('fetchAllAttedanceActivity serice isidfds fdfd ');

    try {
      final resp = await _api.get(ApiEndpoints.getAllMasterDataUrl);
      print('resp is the $resp');
      return resp;
    } catch (e) {
      rethrow;
    }
  }

}
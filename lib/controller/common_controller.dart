// lib/controllers/common_controller.dart

import 'package:get/get.dart'; // Using package:get/get.dart for simplicity
import '../../services/common/common_service.dart';
import '../models/masterData.dart';


class CommonController extends GetxController {

  final CommonService _service = CommonService();

  // FIX: Use Rx<MasterData?> to hold a single nullable MasterData object.
  // Initialize with null or an empty MasterData object.
  final Rx<MasterData?> masterData = Rx<MasterData?>(null);

  // Example list that uses the converted data (List<Map<String, dynamic>>)
  final RxList<Map<String, dynamic>> leaveTypeListMaps = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    getAllMasterData();
  }

  // FIX: Changed return type to Future<void> as the function updates an Rx variable.
  Future<void> getAllMasterData() async {
    print('loadAttendanceActivities called is the ');

    try {
      final Map<String, dynamic> res = await _service.fetchMasterData();
      MasterData masterDataResult = MasterData.fromJson(res);

      // FIX: Use .value to assign the new object to the Rx variable.
      masterData.value = masterDataResult;

    } catch (e) {
      print('Error loading master data: $e');
      // In a real app, you might set an error state here.
    }
  }
}
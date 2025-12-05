import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxInt _activeRequests = 0.obs;

  /// observable used by UI
  RxBool isLoading = false.obs;

  // Optional manual control
  void show() => isLoading.value = true;
  void hide() => isLoading.value = false;

  // Call these in your API wrapper
  void start() {
    _activeRequests.value++;
    isLoading.value = _activeRequests.value > 0;
  }

  void stop() {
    if (_activeRequests.value > 0) {
      _activeRequests.value--;
    }
    isLoading.value = _activeRequests.value > 0;
  }

  void reset() {
    _activeRequests.value = 0;
    isLoading.value = false;
  }
}

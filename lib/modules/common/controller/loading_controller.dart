import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxInt _activeRequests = 0.obs;

  /// observable used by UI
  RxBool isLoading = false.obs;

  void show() {
    _activeRequests.value++;
    isLoading.value = true;
  }

  void hide() {
    if (_activeRequests.value > 0) {
      _activeRequests.value--;
    }
    isLoading.value = _activeRequests.value > 0;
  }

  void start() {
    _activeRequests.value++;
    isLoading.value = true;
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

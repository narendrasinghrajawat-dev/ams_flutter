
class AppHelper {


  static bool isEmptyOrNull(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.trim().isEmpty;
    }
    if (value is Map) {
      return value.isEmpty;
    }

    if (value is Iterable) {
      return value.isEmpty;
    }
    return false;
  }
}

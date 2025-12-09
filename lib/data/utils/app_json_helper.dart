


class AppJsonHelper{

  static String safeString(dynamic v, {String defaultValue = ''}) {
    if (v == null) {
      return defaultValue;
    }
    // Attempt to return the value as a String
    return v.toString();
  }

  /// Converts any dynamic value to a nullable String (String?).
  /// Returns null if the input value is null.
  static String? safeNullableString(dynamic v) {
    if (v == null) {
      return null;
    }
    // If not null, convert to string
    return v.toString();
  }

  static int? safeNullableInt(dynamic v) {
    if (v == null) {
      return null;
    }

    if (v is int) {
      return v;
    }

    if (v is String) {
      return int.tryParse(v);
    }

    if (v is double) {
      if (v == v.truncateToDouble()) {
        return v.toInt();
      }
      return null;
    }

    // For any other type (bool, List, Map, etc.), return null.
    return null;
  }

  /// Converts any dynamic value to a non-nullable bool.
  /// Handles string representations of booleans ("true", "false") and defaults to false.
  static bool safeBool(dynamic v, {bool defaultValue = false}) {
    if (v == null) {
      return defaultValue;
    }
    if (v is bool) {
      return v;
    }
    // Convert string to boolean (case-insensitive check)
    if (v is String) {
      return v.toLowerCase() == 'true';
    }
    // Any other non-null value (like 1, 'Y', etc.) can be treated as true based on context,
    // but a strict 'true'/'false' check is safer. We default to false for non-boolean types.
    return defaultValue;
  }

  /// Converts any dynamic value to a non-nullable double.
  /// Safely handles int, string representations of numbers, and defaults to 0.0.
  static double safeDouble(dynamic v, {double defaultValue = 0.0}) {
    if (v == null) {
      return defaultValue;
    }
    if (v is double) {
      return v;
    }
    if (v is int) {
      return v.toDouble();
    }
    if (v is String) {
      // Attempt to parse the string as a double
      return double.tryParse(v) ?? defaultValue;
    }
    return defaultValue;
  }

}
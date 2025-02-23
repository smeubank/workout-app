import 'package:intl/intl.dart';

class JsonSerializer {
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        try {
          return DateFormat('yyyy-MM-dd HH:mm:ss').parse(value);
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  static Map<String, dynamic> sanitizeJson(Map<String, dynamic> json) {
    return json.map((key, value) {
      if (value == null) return MapEntry(key, null);
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value is Map) return MapEntry(key, sanitizeJson(value as Map<String, dynamic>));
      return MapEntry(key, value);
    });
  }
} 
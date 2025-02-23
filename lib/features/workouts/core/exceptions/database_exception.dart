class DatabaseException implements Exception {
  final String message;
  final String? code;
  final String? details;
  final Map<String, dynamic>? context;

  DatabaseException(
    this.message, {
    this.code,
    String? details,
    this.context,
  }) : details = details ?? '';

  Map<String, dynamic> toSentry() {
    return {
      'message': message,
      'code': code,
      'details': details,
      ...?context,
    };
  }

  @override
  String toString() => message;
} 
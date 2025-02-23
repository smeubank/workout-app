class DatabaseException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  final Map<String, dynamic>? context;

  DatabaseException(
    this.message, {
    this.code,
    this.details,
    this.context,
  });

  Map<String, dynamic> toSentry() {
    return {
      'error_code': code,
      'error_details': details,
      'error_context': context,
    };
  }

  @override
  String toString() {
    return 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
  }
} 
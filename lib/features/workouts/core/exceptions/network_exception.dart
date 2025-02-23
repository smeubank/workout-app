class NetworkException implements Exception {
  final String message;
  final dynamic originalError;

  NetworkException(this.message, {this.originalError});

  @override
  String toString() => message;

  Map<String, dynamic> toSentry() {
    return {
      'message': message,
      'original_error': originalError?.toString(),
    };
  }
} 
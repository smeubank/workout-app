class DatabaseErrorHandler {
  static DatabaseException handleError(dynamic error, String operation, {Map<String, dynamic>? context}) {
    if (error is PostgrestException) {
      return DatabaseException(
        'Failed to $operation',
        code: error.code,
        details: error.details,
        context: {
          ...?context,
          'error_code': error.code,
          'error_details': error.details,
        },
      );
    }
    
    return DatabaseException(
      'Unexpected error while $operation',
      context: context,
    );
  }
} 
import 'package:sentry/sentry.dart';
import '../exceptions/database_exception.dart';
import 'package:postgrest/postgrest.dart';

abstract class BaseRepository {
  Future<T> executeQuery<T>(String operation, Future<T> Function() query) async {
    try {
      return await query();
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation': operation,
          'error': e.toString(),
        }),
      );
      rethrow;
    }
  }
} 
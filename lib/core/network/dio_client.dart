import 'package:dio/dio.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry/sentry.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio();
    
    // Add any global configuration here
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptor to log requests
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            category: 'http',
            message: object.toString(),
            level: SentryLevel.info,
          ),
        );
      },
    ));
    
    // Add Sentry monitoring - must be last
    dio.addSentry(
      failedRequestStatusCodes: [
        SentryStatusCode.range(400, 404),
        SentryStatusCode(500),
      ],
    );
    
    return dio;
  }
} 
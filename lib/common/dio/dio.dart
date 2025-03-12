import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[REQUEST] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final accessToken = await storage.read(key: accessTokenKey);

      options.headers.addAll({
        'authorization': 'Bearer $accessToken',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final refreshToken = await storage.read(key: refreshTokenKey);

      options.headers.addAll({
        'authorization': 'Bearer $refreshToken',
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      '[RESPONSE] [${response.requestOptions.method}] ${response.requestOptions.uri}',
    );

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: refreshTokenKey);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final response = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = response.data['accessToken'];
        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: accessTokenKey, value: accessToken);

        // options 변경 후 재요청
        final fetchResponse = await dio.fetch(options);

        return handler.resolve(fetchResponse);
      } on DioException catch (e) {
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }
}

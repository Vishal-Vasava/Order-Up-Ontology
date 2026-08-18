import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (inject.get<AuthLocalRepository>().token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer ${inject.get<AuthLocalRepository>().token}';
    }
    options.headers['Accept'] = '*/*';
    options.headers['Content-type'] = 'application/json';
    options.baseUrl = inject.get<AuthLocalRepository>().apiUrl;
    log('*** Request ***', name: 'DIO');
    log('Url ${options.uri}', name: 'DIO');
    if (options.data is! FormData) {
      log('Data ${jsonEncode(options.data)}', name: 'DIO');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('*** Response ***', name: 'DIO');
    log(
        jsonEncode(
          response.data,
        ),
        name: 'Response of ${response.realUri.path}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    log('*** Dio Error ***', name: 'DIO');
    log('Url: ${err.requestOptions.uri}', name: 'DIO');
    try {
      if (err.response?.statusCode == 400 ||
          err.response?.statusCode == 401 ||
          err.response?.statusCode == 403) {
        if (err.response?.data['message'] == 'Invalid Token') {
          final result = await _refreshToken();
          if (result != 'success') {
            log('User needs to sign in again');
            await inject.get<FirebaseAuth>().signOut();
            return handler.next(err);
          } else {
            final data = await _retry(err.requestOptions);
            return handler.resolve(data);
          }
        } else {
          return handler.next(err);
        }
      } else if (err.response?.statusCode == 419) {
        log('User needs to sign in again');
        await inject.get<FirebaseAuth>().signOut();
      }
    } catch (e) {
      log(
        e.toString(),
      );
    }
    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final headers = requestOptions.headers;
    headers['Authorization'] =
        'Bearer ${inject.get<AuthLocalRepository>().token}';
    final options = Options(
      method: requestOptions.method,
      headers: headers,
    );
    return inject.get<NetworkAdapter>().dio.request<dynamic>(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options,
        );
  }

  static Future<String> _refreshToken() async {
    try {
      final dio = Dio();
      final auth = inject.get<AuthLocalRepository>();

      if (auth.refreshTokenApi.isEmpty || auth.apiUrl.isEmpty) {
        return 'logout';
      }

      dio.options.headers['Authorization'] = 'Bearer ${auth.refreshTokenApi}';
      dio.options.baseUrl = auth.apiUrl;
      dio.options.connectTimeout =
          const Duration(milliseconds: Config.connectionTimeout);
      dio.options.receiveTimeout =
          const Duration(milliseconds: Config.receiveTimeout);
      dio.options.responseType = ResponseType.json;

      /// REFRESH TOKEN API CALL
      String url = '';
      if (auth.authUser.userType == AuthRole.agent.name) {
        url = Endpoints.agentRefreshToken;
      } else if (auth.authUser.userType == AuthRole.consumer.name) {
        url = Endpoints.customerRefreshToken;
      } else {
        url = Endpoints.storeRefreshToken;
      }

      final response = await dio.get(
        url,
      );
      if (response.statusCode! == 419) {
        return 'logout';
      }
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final result = response.data;
        final data = result is Map ? result['data'] : null;
        final tokens = data is Map ? data['tokens'] : null;
        final accessToken = result is Map && result['statusCode'] == 200
            ? (tokens is Map ? tokens['access_token'] : null)
            : (result is Map ? result['access_token'] : null);
        final refreshToken = result is Map && result['statusCode'] == 200
            ? (tokens is Map ? tokens['refresh_token'] : null)
            : (result is Map ? result['refresh_token'] : null);
        if (accessToken is String &&
            accessToken.isNotEmpty &&
            refreshToken is String &&
            refreshToken.isNotEmpty) {
          await auth.setAccessToken(accessToken);
          await auth.setRefreshToken(refreshToken);
          return 'success';
        }
        return 'logout';
      } else if (response.statusCode! == 419) {
        return 'logout';
      } else {
        return '';
      }
    } on DioException catch (e) {
      log(e.toString());
      if (e.response?.statusCode == 419) {
        return 'logout';
      } else {
        return 'logout';
      }
    }
  }
}

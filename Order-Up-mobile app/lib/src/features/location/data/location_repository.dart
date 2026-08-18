import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class LocationRepository {
  LocationRepository({
    required this.networkAdapter,
    required this.authLocalRepository,
  });

  final NetworkAdapter networkAdapter;
  final AuthLocalRepository authLocalRepository;

  Future<String> getApiUrl({required String countryCode}) async {
    try {
      final finalUrl = '${Endpoints.apiHost}/$countryCode';
      final dio = Dio()
        ..options.headers['Accept'] = '*/*'
        ..options.headers['Content-type'] = 'application/json'
        ..options.connectTimeout =
            const Duration(milliseconds: Config.connectionTimeout)
        ..options.receiveTimeout =
            const Duration(milliseconds: Config.receiveTimeout)
        ..options.responseType = ResponseType.json
        ..options.baseUrl = Config.baseUrl;
      final response = await dio.get(finalUrl);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          final url = response.data['data'];
          await authLocalRepository.setApiUrl(url);
          return authLocalRepository.apiUrl;
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
    return '';
  }
}

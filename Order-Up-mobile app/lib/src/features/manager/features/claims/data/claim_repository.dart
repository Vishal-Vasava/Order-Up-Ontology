import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/data/claim_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/domain/claim.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class ClaimRepository extends ClaimAdapter {
  ClaimRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<Claim?> getClaimList() async {
    try {
      const String url = Endpoints.storeClaims;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return Claim.fromJson(response.data['data']);
        } else {
          return null;
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return null;
  }
}

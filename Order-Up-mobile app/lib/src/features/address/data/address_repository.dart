import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/constants/app_keys.dart';
import 'package:orderly_ecom/src/features/address/data/address_adapter.dart';
import 'package:orderly_ecom/src/features/address/domain/address.dart' as ad;
import 'package:orderly_ecom/src/features/address/domain/address_model.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class AddressRepository extends AddressInterface {
  AddressRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<List<ad.Address>> getAddressList() async {
    try {
      const String url = Endpoints.customerAddress;
      final response = await networkAdapter.get(url);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return (response.data['data'] as List)
              .map((e) => ad.Address.fromJson(e))
              .toList();
        } else {
          throw const AppException(message: 'Try Again');
        }
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> addAddress({required AddressModel model}) async {
    try {
      const String url = Endpoints.customerAddAddress;
      final data = model.toJson();
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw const AppException(message: 'Try Again');
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> deleteAddress({required String addressId}) async {
    try {
      final String url = '${Endpoints.customerDeleteAddress}/$addressId';
      final response = await networkAdapter.delete(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw const AppException(message: 'Try Again');
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> updateAddress({
    required String addressId,
    required AddressModel model,
  }) async {
    try {
      final String url = '${Endpoints.customerUpdateAddress}/$addressId';
      final data = model.toJson();
      final response = await networkAdapter.put(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw const AppException(message: 'Try Again');
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<String> getPaymentUrl({required String countryCode}) async {
    try {
      final String url = '${Endpoints.paymentConfig}/:$countryCode';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          final data = response.data['data'];
          final method = data['method'];
          if (method.toString().toLowerCase() == 'razorpay') {
            inject.get<AuthLocalRepository>().setRazorpayKey(data['key']);
          } else {
            await Future.wait([
              inject
                  .get<AuthLocalRepository>()
                  .setStripePublishableKey(data['publishable_key']),
              inject.get<AuthLocalRepository>().setStripeSecretKey(
                    data['secret_key'],
                  ),
              inject
                  .get<AuthLocalRepository>()
                  .setStripeSecretKey(data['secret_key']),
              inject.get<AuthLocalRepository>().setStripeMerchantId(
                    data['merchant_id'],
                  ),
            ]);
            Stripe.publishableKey = data['publishable_key'];
            Stripe.merchantIdentifier = AppKey.stripeMerchantId;
            Stripe.urlScheme = 'flutterstripe';
            await Stripe.instance.applySettings();
          }
          return response.data['data']['method'];
        } else {
          throw const AppException(message: 'Try Again');
        }
      } else {
        return '';
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/data/offer_interface.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/all_offers.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/new_customer_product.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/offers_by_id.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class OfferRepository extends OfferInterface {
  OfferRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;
  @override
  Future<ProductCustomer?> getProductCustomer() async {
    try {
      const String url = Endpoints.productCustomerList;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return ProductCustomer.fromJson(response.data);
        // if (response.data['msg'] == 'Success') {
        //   return ProductCustomer.fromJson(response.data);
        // } else {
        //   return null;
        // }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return null;
  }

  @override
  Future<AllOffers?> getAllOffers() async {
    try {
      debugPrint(inject.get<AuthLocalRepository>().accessToken);
      const String url = Endpoints.getAllOffers;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return AllOffers.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> deleteOffers({
    required String id,
  }) async {
    try {
      String url = '/store/offer/remove/$id';
      final response = await networkAdapter.delete(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['data']['isRemoved'] == true) {
          return true;
        } else {
          return false;
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return false;
  }

  @override
  Future<OffersById?> getOffersById({
    required String id,
  }) async {
    try {
      String url = '/store/offer/$id';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return OffersById.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> createOffers(
      {required String title,
      required int offerPercentage,
      required String startDate,
      required String endDate,
      required int status,
      required List<String> products,
      required List<String> customers}) async {
    try {
      const String url = Endpoints.createOffers;
      final data = {
        'title': title,
        'offerPercentage': offerPercentage,
        'startDate': startDate,
        'endDate': endDate,
        'status': status,
        'products': products,
        'customers': customers,
      };
      final response = await networkAdapter.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['data']['status'] == true) {
          return true;
        } else {
          return false;
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return false;
  }

  @override
  Future<bool> updateOffers({
    required String title,
    required String id,
    required int offerPercentage,
    required String startDate,
    required String endDate,
    required int status,
    required List<String> products,
    required List<String> customers,
  }) async {
    try {
      String url = '/store/offer/update/$id';
      final data = {
        'title': title,
        'offerPercentage': offerPercentage,
        'startDate': startDate,
        'endDate': endDate,
        'status': status,
        'products': products,
        'customers': customers,
      };
      final response = await networkAdapter.put(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['data']['status'] == true) {
          return true;
        } else {
          return false;
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return false;
  }

  // @override
  // Future<bool> updateOffers({
  //   required int offerId,
  //   required int offerPercentage,
  //   required String startDate,
  //   required String endDate,
  //   required int status,
  //   required List<int> products,
  //   required List<int> customers,
  // }) async {
  // try {
  //   String url = '/updateOffer';
  //   final data = {
  //     'offer_id': offerId,
  //     'offer_per': offerPercentage,
  //     'start_date': startDate,
  //     'end_date': endDate,
  //     'status': status,
  //     'products': products,
  //     'customers': customers,
  //   };
  //   final response = await networkAdapter.post(url);
  //   if (response.statusCode! >= 200 && response.statusCode! <= 299) {
  //     if (response.data['msg'] == 'successed') {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // } on DioException catch (e) {
  //   throw DioExceptions.fromDioError(e);
  // }
  // return false;
  // }
}

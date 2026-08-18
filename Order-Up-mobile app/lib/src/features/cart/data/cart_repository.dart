import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/cart/data/cart_adapter.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart_place_order.dart';
import 'package:orderly_ecom/src/features/cart/domain/cart.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class CartRepository extends CartAdapter {
  CartRepository({
    required this.networkAdapter,
  });

  final NetworkAdapter networkAdapter;

  @override
  Future<bool> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      const String url = Endpoints.cartAdd;
      final data = {
        'product_id': productId,
        'qty': quantity,
      };
      log(jsonEncode(data), name: 'ADD TO CART');
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else if (response.data['statusCode'] == 201) {
          throw AppException(
              message: response.data['message']
                  .toString()
                  .replaceAll('API Error:', '')
                  .trim());
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
  Future<Cart?> getCartList({
    required String latitude,
    required String longitude,
  }) async {
    try {
      const String url = Endpoints.cartView;
      final data = {'latitude': latitude, 'longitude': longitude};
      // final data = {'latitude': '57.5050', 'longitude': '12.4556'};
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return Cart.fromJson(response.data['data']);
        } else {
          throw const AppException(message: 'Please try again');
        }
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> updateCart({
    required String productId,
    required String quantity,
  }) async {
    try {
      const String url = Endpoints.cartUpdate;
      final data = {
        'product_id': productId,
        'qty': quantity,
      };
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
      } else if (response.data['status'] == 201) {
        throw Exception('Please try again');
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> deleteCart({
    required String productId,
  }) async {
    try {
      const String url = Endpoints.cartDelete;
      final data = {
        'product_id': productId,
      };
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw const AppException(message: 'Please try again');
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  @override
  Future<bool> checkAddressOnOrder({
    required String addressId,
  }) async {
    try {
      final String url = '${Endpoints.shoppingAddressCheck}/$addressId';
      final response = await networkAdapter.get(url);
      if (response.statusCode == 200) {
        if (response.data['statusCode'] == 200) {
          if (response.data['data']['item_status']['all_items_available']) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  // @override
  // Future getCharges() async {
  //   try {
  //     const String url = Endpoints.getCharges;
  //     final response = await networkAdapter.get(url);
  //     if (response.statusCode == 200) {
  //       return response.data;
  //     }
  //   } on DioException catch (e) {
  //     throw DioExceptions.fromDioError(e).toString();
  //   }
  // }

  @override
  Future<bool> placeOrder({
    required CartPlaceOrder placeOrder,
  }) async {
    try {
      const String url = Endpoints.shoppingOrderPlace;
      final data = placeOrder.toJson();
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw const AppException(message: 'Please try again');
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}

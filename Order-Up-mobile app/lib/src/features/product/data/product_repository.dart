import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/product/data/product_adapter.dart';
import 'package:orderly_ecom/src/features/product/domain/banners.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class ProductRepository extends ProductAdapter {
  ProductRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<Product?> getProductList({
    required String storeId,
    required String nextCursor,
    required bool isRefresh,
    List<String>? filters,
  }) async {
    try {
      const String url = Endpoints.storeProducts;
      Map<String, dynamic> data = {};
      data['store_id'] = storeId;
      if (filters != null) {
        if (filters.isNotEmpty && !filters.contains('0')) {
          data['_filters'] = filters;
        }
      }
      if (nextCursor.isNotEmpty) {
        data['next_cursor'] = nextCursor;
      }
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        debugPrint(inject.get<AuthLocalRepository>().accessToken);
        if (response.data['statusCode'] == 200) {
          return Product.fromJson(response.data['data']);
        } else if (response.data['statusCode'] == 500) {
          throw const AppException(message: 'No result found');
        } else {
          return null;
        }
      } else {
        throw const AppException(message: 'Couldn\'t fetch orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<ProductData?> getProductDetail({required String productId}) async {
    try {
      final String url = '${Endpoints.storeProductDetail}/$productId';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return ProductData.fromJson(response.data['data']);
        } else {
          throw const AppException(message: 'Try again');
        }
      } else {
        throw const AppException(message: 'Couldn\'t fetch orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<List<Filters>> getFilters() async {
    try {
      const url = Endpoints.storeProductFilterList;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          List<Filters> filters = (response.data['data'] as List)
              .map((e) => Filters.fromJson(e))
              .toList();
          // filters.insert(
          //   0,
          //   Filters(
          //     id: '0',
          //     name: 'All',
          //     description: 'All',
          //     icon: '',
          //     iconUrl: '',
          //     filtersId: '0',
          //   ),
          // );
          return filters;
        } else {
          throw AppException(
            message: "${response.data['statusCode']} : Please try again",
          );
        }
      } else {
        throw const AppException(
          message: 'Something went wrong',
        );
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<List<Banners>> getBanners() async {
    try {
      const url = Endpoints.getBanners;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          List<Banners> banners = (response.data['data'] as List)
              .map((e) => Banners.fromJson(e))
              .toList();
          return banners;
        } else {
          throw AppException(
            message: "${response.data['statusCode']} : Please try again",
          );
        }
      } else {
        throw const AppException(
          message: 'Something went wrong',
        );
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  void searchProduct({required String search}) => throw UnimplementedError();
}

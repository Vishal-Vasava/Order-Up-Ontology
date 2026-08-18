import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/data/inventory_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/create_estimates.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory_model.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/pickup_estimates.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/product_reason.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/sku_gallery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class InventoryRepository extends InventoryAdapter {
  InventoryRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<Inventory?> getInventoryList() async {
    try {
      const url = Endpoints.storeViewInventory;
      final response = await networkAdapter.post(
        url,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return Inventory.fromJson(response.data['data']);
        } else {
          throw AppException(message: response.data['msg']);
        }
      } else {
        throw const AppException(message: 'Please refresh the page');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> addInventory({required InventoryModel inventoryModel}) async {
    try {
      const url = Endpoints.storeCreateInventory;
      // final Map<String, dynamic> mapData = {
      //   'name': inventoryModel.productName,
      //   'desc': inventoryModel.productDesc,
      //   'price': inventoryModel.rate,
      //   'qty': inventoryModel.productQty,
      // };
      // if (inventoryModel.image != null) {
      //   mapData['image'] = await MultipartFile.fromFile(
      //     inventoryModel.image!.path,
      //     filename: inventoryModel.image!.path.split('/').last,
      //     contentType: MediaType(
      //       'image',
      //       'JPEG',
      //     ),
      //   );
      // }

      String fileName = inventoryModel.image?.path ?? '';

      final map = {
        'image': inventoryModel.image == null
            ? ''
            : await MultipartFile.fromFile(
                inventoryModel.image!.path,
                filename: fileName,
                contentType: MediaType(
                  'image',
                  'JPEG',
                ),
              ),
        'name': inventoryModel.productName,
        'desc': inventoryModel.productDesc,
        'price': inventoryModel.rate,
        'qty': inventoryModel.productQty,
        'image_id': inventoryModel.imageId,
        '_returnPolicy': inventoryModel.returnPolicy,
        '_estimatedPickup': inventoryModel.estimatedPickup,
        '_filters': inventoryModel.filters,
      };
      if (inventoryModel.image == null) {
        map.removeWhere((key, value) => key == 'image');
      }

      FormData formData = FormData.fromMap(map);
      final response = await networkAdapter.post(
        url,
        data: formData,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> editInventory({required InventoryModel inventoryModel}) async {
    try {
      final String url =
          '${Endpoints.storeUpdateInventory}/${inventoryModel.productId!}';
      final Map<String, dynamic> mapData = {
        'name': inventoryModel.productName,
        'desc': inventoryModel.productDesc,
        'price': inventoryModel.rate,
        'qty': inventoryModel.productQty,
        '_returnPolicy': inventoryModel.returnPolicy,
        '_estimatedPickup': inventoryModel.estimatedPickup,
        '_filters': inventoryModel.filters,
      };
      if (inventoryModel.image != null) {
        mapData['image'] = await MultipartFile.fromFile(
          inventoryModel.image!.path,
          filename: inventoryModel.image!.path.split('/').last,
          contentType: MediaType(
            'image',
            'JPEG',
          ),
        );
      }
      FormData formData = FormData.fromMap(mapData);
      final response = await networkAdapter.put(
        url,
        data: formData,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw AppException(message: response.data['msg']);
        }
      } else {
        throw Exception(response.data['msg']);
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> deleteInventory({required String productId}) async {
    try {
      final String url = '${Endpoints.storeDeleteInventory}/$productId';
      final response = await networkAdapter.delete(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          if (response.data['data']['product']['deleted']) {
            return true;
          } else {
            return false;
          }
        } else {
          throw Exception(response.data['msg']);
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<SkuGallery?> getGalleryList({
    required String searchDish,
    required int pageNumber,
  }) async {
    try {
      const url = Endpoints.skuGalleryList;
      debugPrint(inject.get<AuthLocalRepository>().accessToken);
      final data = {
        'search': searchDish,
        'page': pageNumber,
      };
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return SkuGallery.fromJson(response.data);
      } else {
        throw const AppException(message: 'Please refresh the page');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<XFile?> pickImage({required ImageSource imageSource}) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final data = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 80,
      );
      return data;
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductReason?> getProductReason() async {
    try {
      const url = Endpoints.getProductReason;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return ProductReason.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
    return null;
  }

  @override
  Future<PickupEstimates?> getPickupEstimates() async {
    try {
      const url = Endpoints.getPickupEstimates;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final data = PickupEstimates.fromJson(response.data);
        return data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<CreateEstimates?> createEstimates({
    required String title,
  }) async {
    try {
      const url = Endpoints.createEstimates;
      final data = {
        'title': title,
      };
      final response = await networkAdapter.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return CreateEstimates.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
    return null;
  }

  @override
  Future<List<Filters>> getFilters() async {
    try {
      const url = Endpoints.storeFilters;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return (response.data['data'] as List)
              .map((e) => Filters.fromJson(e))
              .toList();
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
}

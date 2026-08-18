import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/delivery/data/delivery_interface.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery.dart';
import 'package:orderly_ecom/src/features/delivery/domain/delivery_order_detail.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';

class DeliveryRepository extends DeliveryInterface {
  DeliveryRepository({required this.networkAdapter});
  final NetworkAdapter networkAdapter;

  @override
  Future<List<Delivery>> getOrders({required String status}) async {
    try {
      const String url = Endpoints.agentOrders;
      final data = {'status': status};
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        debugPrint(inject.get<AuthLocalRepository>().accessToken);
        if (response.data['statusCode'] == 200) {
          return (response.data['data']['data'] as List)
              .map((e) => Delivery.fromJson(e))
              .toList();
        } else {
          return [];
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return [];
  }

  @override
  Future<DeliveryOrderDetail?> orderDetail({
    required String orderDetailId,
  }) async {
    try {
      final String url = '${Endpoints.agentOrderDetail}/$orderDetailId';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return DeliveryOrderDetail.fromJson(response.data['data']);
        } else {
          return null;
        }
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
    return null;
  }

  @override
  Future<bool> updateOrderStatus({
    required List<String> orderDetailId,
    required String status,
  }) async {
    try {
      const url = Endpoints.agentOrderStatusUpdate;
      final data = {
        'order_items_id': orderDetailId,
        'status': status,
      };
      final response = await networkAdapter.post(url, data: data);
      if (response.statusCode == 200) {
        if (response.data['statusCode'] == 200) {
          return true;
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
}

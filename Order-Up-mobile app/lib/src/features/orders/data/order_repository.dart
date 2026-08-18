import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/orders/data/order_adapter.dart';
import 'package:orderly_ecom/src/features/orders/domain/invoice.dart';
import 'package:orderly_ecom/src/features/orders/domain/invoice_model.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/domain/product_return_reason.dart';
import 'package:orderly_ecom/src/features/orders/domain/track_order.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class OrderRepository extends OrderAdapter {
  OrderRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<List<Order>> getOrderList({
    required String timeType,
    required String duration,
    required String status,
  }) async {
    try {
      const String url = Endpoints.ordersView;
      final data = timeType.isEmpty
          ? {'filter': {}}
          : {
              'filter': {
                'time': {
                  'type': timeType,
                  'duration': duration,
                },
                'status': status
              }
            };

      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        debugPrint(inject.get<AuthLocalRepository>().accessToken);
        if (response.data['statusCode'] == 200) {
          return (response.data['data']['orders'] as List)
              .map((e) => Order.fromJson(e))
              .toList();
        } else {
          throw AppException(message: response.data['msg']);
        }
      } else {
        throw const AppException(message: 'Couldn\'t fetch orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<Invoice?> downloadInvoice({required String orderId}) async {
    try {
      final String url = '${Endpoints.shoppingOrderInvocie}/$orderId';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          final InvoiceModel invoiceResp =
              InvoiceModel.fromJson(response.data['data']);
          final invoice = Invoice(
            supplier: const Supplier(
              name: 'dfdfdf',
              address: 'dfdfdf',
              paymentInfo: '',
            ),
            customer: Customer(
              name:
                  '${inject.get<AuthLocalRepository>().userBox.values.elementAt(0).firstName} ${inject.get<AuthLocalRepository>().userBox.values.elementAt(0).lastName}',
              address: inject.get<AuthLocalRepository>().userAddress,
            ),
            info: InvoiceInfo(
              number: invoiceResp.invoiceNumber!,
              totalAmt: invoiceResp.orderTotal!.toString(),
              date: DateFormat(StaticText.dateFormat)
                  .format(invoiceResp.createdAt!),
              description: '',
              dueDate: DateTime.now(),
              conveyanceFee: invoiceResp.conveyanceCharge!.toString(),
              deliveryCharges: invoiceResp.deliveryCharge!.toString(),
            ),
            items: [
              ...List.generate(invoiceResp.orderItems?.length ?? 0, (index) {
                return invoiceResp.orderItems![index];
              })
            ],
          );
          return invoice;
        } else {
          throw AppException(message: response.data['msg']);
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<TrackOrder?> trackOrder({required String orderDetialId}) async {
    try {
      final String url = '${Endpoints.orderTrack}/$orderDetialId';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return TrackOrder.fromJson(response.data['data']);
        } else {
          throw AppException(message: response.data['msg']);
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<bool> addReview({
    required String orderDetailId,
    required String appRating,
    required String productRating,
    required String orderRating,
    required String paymentRaing,
    required String overall,
    required String comment,
  }) async {
    try {
      const String url = Endpoints.addReview;
      final data = {
        'order_detail_id': orderDetailId,
        'app_rating': appRating,
        'product_rating': productRating,
        'order_rating': orderRating,
        'payment_rating': paymentRaing,
        'overall_rating': overall,
        'review': comment,
      };
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          throw AppException(message: response.data['message']);
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<String> getPaymentUrl() async {
    try {
      const String url = Endpoints.paymentUrl;
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return response.data['data']['url'];
        } else {
          throw AppException(message: response.data['message']);
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  @override
  Future<ProductReturnReason?> getReturnProductReasonById({
    required String id,
    required String type,
  }) async {
    try {
      String url = '/customer/reason/get/$id/$type';
      final response = await networkAdapter.get(url);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return ProductReturnReason.fromJson(response.data);
      }
    } on DioException catch (e) {
      log(e.toString(), name: 'ERROR??????????????????????');
    }
    return null;
  }

  @override
  Future<bool> returnReplaceOrder({
    required String status,
    required String reason,
    required String order,
    required String orderItem,
  }) async {
    try {
      String url = Endpoints.returnReplaceOrder;
      final data = {
        'status': status,
        'reason': reason,
        '_order': order,
        '_orderItem': orderItem
      };
      final response = await networkAdapter.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}

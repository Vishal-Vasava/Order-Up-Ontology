import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/orders/data/order_adapter.dart';
import 'package:orderly_ecom/src/features/orders/domain/invoice.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/domain/product_return_reason.dart';
import 'package:orderly_ecom/src/features/orders/domain/track_order.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> implements OrderAdapter {
  OrderCubit({required this.orderAdapter}) : super(OrderInitialState());
  final OrderAdapter orderAdapter;

  List<Order> orderList = [];
  @override
  Future<List<Order>> getOrderList({
    required String timeType,
    required String duration,
    required String status,
  }) async {
    try {
      emit(OrderLoadingState());
      final list = await orderAdapter.getOrderList(
        timeType: timeType,
        duration: duration,
        status: status,
      );
      orderList = list;
      emit(OrderLoadedState(
        orderList: orderList,
        searchOrderList: const [],
      ));
    } catch (e) {
      emit(OrderFailedState(message: e.toString()));
    }
    return [];
  }

  @override
  void searchOrders({required String searchText}) {
    try {
      emit(OrderSearchState());
      if (searchText.isNotEmpty) {
        String search = searchText.toLowerCase();
        List<Order> searchList = [];

        for (final value in orderList) {
          if (DateFormat(StaticText.dateFormat)
                  .format(value.createdAt!)
                  .toLowerCase()
                  .contains(search) ||
              value.orderId!.toString().contains(search) ||
              value.orderNumber!.toLowerCase().contains(search)) {
            searchList.add(value);
          }
        }
        emit(OrderLoadedState(
            orderList: orderList, searchOrderList: searchList));
      } else {
        emit(OrderLoadedState(orderList: orderList, searchOrderList: const []));
      }
    } catch (e) {
      emit(OrderFailedState(message: e.toString()));
    }
  }

  @override
  Future<Invoice?> downloadInvoice({required String orderId}) async {
    try {
      final data = await orderAdapter.downloadInvoice(orderId: orderId);
      return data;
    } catch (e) {
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'Download Invoice Error');
    }
    return null;
  }

  @override
  Future<TrackOrder?> trackOrder({required String orderDetialId}) async {
    try {
      emit(OrderTrackLoadingState());
      final data = await orderAdapter.trackOrder(orderDetialId: orderDetialId);
      emit(OrderTrackLoadedState(
          trackOrder: data!, cancelReason: data.cancelReason ?? ''));
    } catch (e) {
      emit(OrderTrackFailedState(message: e.toString()));
    }
    return null;
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
      emit(OrderAddReviewLoadingState());
      final success = await orderAdapter.addReview(
        orderDetailId: orderDetailId,
        appRating: appRating,
        productRating: productRating,
        orderRating: orderRating,
        paymentRaing: paymentRaing,
        overall: overall,
        comment: comment,
      );
      if (success) {
        await getOrderList(
          timeType: '',
          duration: '',
          status: 'pending',
        );
        emit(OrderAddReviewSuccessState());
      } else {
        emit(const OrderAddReviewFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(OrderAddReviewFailedState(message: e.toString()));
    }
    return false;
  }

  @override
  Future<String> getPaymentUrl() async {
    try {
      emit(OrderPaymenUrlLoadingState());
      final data = await orderAdapter.getPaymentUrl();
      if (data.isNotEmpty) {
        emit(OrderPaymenUrlLoadedState(data));
      } else {
        emit(const OrderPaymenUrlFailedState('Please try again'));
      }
    } catch (e) {
      emit(OrderPaymenUrlFailedState(e.toString()));
    }
    return '';
  }

  @override
  Future<ProductReturnReason?> getReturnProductReasonById({
    required String id,
    required String type,
  }) async {
    try {
      emit(OrderReturnReasonLoadingState());
      final data =
          await orderAdapter.getReturnProductReasonById(id: id, type: type);
      if (data != null) {
        emit(OrderReturnReasonLoadedState(productReasonList: data));
      }
    } catch (e) {
      emit(OrderReturnReasonFailedState(message: e.toString()));
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
      final data = await orderAdapter.returnReplaceOrder(
          status: status, reason: reason, order: order, orderItem: orderItem);
      if (data) {
        emit(OrderReturnReplaceLoadedState(status: data));
      } else {
        emit(const OrderReturnReplaceFailedState(
            message: 'Please try again later'));
      }
    } catch (e) {
      OrderReturnReplaceFailedState(message: e.toString());
    }
    return false;
  }
}

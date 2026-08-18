import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/data/manager_order_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/domain/manager_order_detail.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'manager_order_state.dart';

class ManagerOrderCubit extends Cubit<ManagerOrderState>
    implements ManagerOrderAdapter {
  ManagerOrderCubit({required this.orderAdapter})
      : super(ManagerOrderInitialState());

  final ManagerOrderAdapter orderAdapter;

  String currentStatusId = 'pending';
  @override
  Future<List<ManagerOrder>> getOrderList({
    required String status,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        emit(ManagerOrderLoadingState());
      } else {
        emit(ManagerOrderInitialState());
      }
      final orderList = await orderAdapter.getOrderList(status: status);
      emit(ManagerOrderLoadedState(orderList: orderList));
      debugPrint(inject.get<AuthLocalRepository>().accessToken);
      return orderList;
    } catch (e, stk) {
      emit(ManagerOrderFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString(), stack: stk);
    }
    return [];
  }

  ManagerOrderDetail? managerOrderDetail;
  @override
  Future<ManagerOrderDetail?> getOrderDetail({
    required String orderId,
    required String status,
  }) async {
    try {
      emit(ManagerOrderDetailLoadingState());
      final orderList = await orderAdapter.getOrderDetail(
        orderId: orderId,
        status: status,
      );
      managerOrderDetail = orderList;
      emit(ManagerOrderDetailLoadedState(orderDetail: orderList));
    } catch (e, stk) {
      emit(ManagerOrderDetailFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString(), stack: stk);
    }
    return null;
  }

  @override
  void updateOrderListCheck({required bool value, required String productId}) {
    try {
      emit(ManagerOrderStatusUiLoadingState());
      managerOrderDetail = managerOrderDetail!.copyWith(
        orders: managerOrderDetail!.orderItems!.map((e) {
          if (e.id! == productId) {
            return e.copyWith(isChecked: value);
          } else {
            return e;
          }
        }).toList(),
      );
      emit(ManagerOrderDetailLoadedState(orderDetail: managerOrderDetail));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> updateOrderStatus({
    required List<String> orderDetailId,
    required String orderStatus,
    String? reason,
  }) async {
    try {
      emit(ManagerOrderStatusLoadingState());
      final success = await orderAdapter.updateOrderStatus(
        orderDetailId: orderDetailId,
        orderStatus: orderStatus,
        reason: reason,
      );
      if (success) {
        await getOrderList(status: currentStatusId.toString());
        emit(ManagerOrderStatusSuccessState());
      } else {
        emit(const ManagerOrderStatusFailedState(
            message: 'Failed to update status'));
      }
    } catch (e, stk) {
      emit(ManagerOrderStatusFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString(), stack: stk);
    }
    return false;
  }

  @override
  Future<List<String>> getCancelReason() async {
    try {
      final data = await orderAdapter.getCancelReason();
      data.add('Other');
      return data;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}

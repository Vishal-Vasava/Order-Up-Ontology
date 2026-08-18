import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/address/data/address_adapter.dart';
import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/address/domain/address_model.dart';
import 'package:orderly_ecom/src/features/cart/screens/cubit/cart_cubit.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> implements AddressInterface {
  AddressCubit({required this.addressAdapter}) : super(AddressInitialState());
  final AddressInterface addressAdapter;

  List<Address> addressList = [];
  @override
  Future<List<Address>> getAddressList({bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(AddressLoadingState());
      }
      final list = await addressAdapter.getAddressList();
      addressList = list;
      emit(AddressLoadedState(
          addressList: addressList,
          sourceAddressId: addressList.isNotEmpty ? addressList[0].id! : '',
          destinationAddressId:
              addressList.isNotEmpty ? addressList[0].id! : ''));
    } catch (e) {
      emit(AddressFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'View Address Error');
    }
    return [];
  }

  String selectedAddressId = '';
  Address? address;
  void selectAddress({String? addressId, String? destinationAddressId}) {
    final currentState = state as AddressLoadedState;
    selectedAddressId = destinationAddressId!;
    address = currentState.addressList
        .firstWhere((element) => element.id! == destinationAddressId);
    emit(AddressLoadingState());
    emit(currentState.copyWith(
        sourceAddressId: addressId,
        destinationAddressId: destinationAddressId));
  }

  @override
  Future<bool> addAddress({required AddressModel model}) async {
    try {
      emit(AddressAddLoadingState());
      final success = await addressAdapter.addAddress(model: model);
      if (success) {
        emit(AddressAddSuccessState());
      } else {
        emit(const AddressAddFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(AddressAddFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'Add Address Error');
    } finally {
      await getAddressList(showLoading: false);
    }
    return false;
  }

  @override
  Future<bool> deleteAddress({required String addressId}) async {
    try {
      emit(AddressDeleteLoadingState());
      final success = await addressAdapter.deleteAddress(addressId: addressId);
      if (success) {
        emit(AddressDeleteSuccessState());
      } else {
        emit(const AddressAddFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(AddressDeleteFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'Delete Address Error');
    } finally {
      await getAddressList(showLoading: false);
    }
    return false;
  }

  @override
  Future<bool> updateAddress({
    required String addressId,
    required AddressModel model,
  }) async {
    try {
      emit(AddressUpdateLoadingState());
      final data = await addressAdapter.updateAddress(
        addressId: addressId,
        model: model,
      );
      if (data) {
        emit(AddressUpdateSuccessState());
        await getAddressList(showLoading: false);
      }
    } catch (e) {
      emit(AddressUpdateFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'Update Address Error');
    }
    return false;
  }

  @override
  Future<String> getPaymentUrl({required String countryCode}) async {
    try {
      final result =
          await addressAdapter.getPaymentUrl(countryCode: countryCode);
      return result;
    } catch (e) {
      emit(AddressFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: 'View Address Error');
    }
    return '';
  }

  Future<void> checkAddressBeforeOrder({
    required BuildContext context,
    required List<Address> addressList,
    required String destinationAddressId,
    required String sourceAddressId,
  }) async {
    try {
      emit(AddressCheckLoadingState());
      String address = '';
      final addressModel = addressList
          .firstWhere((element) => element.id! == destinationAddressId);

      address = addressModel.address ?? '';
      bool isCartValid = false;
      isCartValid = await context
          .read<CartCubit>()
          .checkAddressOnOrder(addressId: destinationAddressId.toString());
      if (isCartValid) {
        final result = await getPaymentUrl(countryCode: addressModel.country!);
        if (result.isNotEmpty) {
          emit(AddressCheckSuccessState(address: address));
        } else {
          emit(const AddressCheckFailedState(
            message: 'Something went wrong',
          ));
        }
      } else {
        emit(const AddressCheckFailedState(
          message: 'Some items from cart are not available on this address',
        ));
      }
    } catch (e) {
      emit(AddressCheckFailedState(message: e.toString()));
    } finally {
      emit(AddressLoadedState(
          sourceAddressId: sourceAddressId,
          destinationAddressId: destinationAddressId,
          addressList: addressList));
    }
  }
}

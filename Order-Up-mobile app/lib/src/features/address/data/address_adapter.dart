import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/features/address/domain/address_model.dart';

abstract class AddressInterface {
  Future<List<Address>> getAddressList();

  Future<bool> addAddress({required AddressModel model});

  Future<bool> updateAddress({
    required String addressId,
    required AddressModel model,
  });

  Future<bool> deleteAddress({required String addressId});

  Future<String> getPaymentUrl({required String countryCode});
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/data/offer_interface.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/all_offers.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/new_customer_product.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/offers_by_id.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OfferCubit extends Cubit<OfferState> implements OfferInterface {
  OfferCubit({required this.offerInterface})
      : super(OfferCustomerProductInitialState());

  final OfferInterface offerInterface;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  @override
  Future<ProductCustomer?> getProductCustomer() async {
    try {
      emit(OfferCustomerProductLoadingState());
      final data = await offerInterface.getProductCustomer();
      if (data != null) {
        emit(OfferCustomerProductLoadedState(productCustomerList: data));
        return data;
      }
    } catch (e) {
      emit(OfferCustomerProductFailedState(message: e.toString()));
    }
    return null;
  }

  @override
  Future<AllOffers?> getAllOffers() async {
    try {
      emit(AllOfferstLoadingState());
      final data = await offerInterface.getAllOffers();
      if (data != null) {
        emit(AllOffersLoadedState(allOfferList: data));
      } else {
        emit(const AllOffersFailedState(message: 'Try After Some Time'));
      }
    } catch (e) {
      emit(AllOffersFailedState(message: e.toString()));
    }
    return null;
  }

  @override
  Future<bool> deleteOffers({
    required String id,
  }) async {
    try {
      emit(DeleteOfferstLoadingState());
      final success = await offerInterface.deleteOffers(id: id);
      if (success) {
        emit(DeleteOffersSuccessState());
      } else {
        emit(const DeleteOffersFailedState(message: 'Please Try Again Later'));
      }
      await getAllOffers();
    } catch (e) {
      emit(DeleteOffersFailedState(message: e.toString()));
    }
    return false;
  }

  List<OffersById> existingProducts = [];
  @override
  Future<OffersById?> getOffersById({
    required String id,
  }) async {
    try {
      emit(OfferByIdLoadingState());
      final data = await offerInterface.getOffersById(id: id);
      if (data != null) {
        emit(OfferByIdLoadedState(offerByIdList: data));
      }
    } catch (e) {
      emit(OfferByIdFailedState(message: e.toString()));
    }
    return null;
  }

  @override
  Future<bool> createOffers({
    required String title,
    required int offerPercentage,
    required String startDate,
    required String endDate,
    required int status,
    required List<String> products,
    required List<String> customers,
  }) async {
    try {
      final data = await offerInterface.createOffers(
          title: title,
          offerPercentage: offerPercentage,
          startDate: startDate,
          endDate: endDate,
          status: status,
          products: products,
          customers: customers);
      if (data) {
        emit(OfferCreateSuccessState());
      } else {
        emit(const OfferCreateFailedState(message: 'Please Try Again'));
      }
      await getAllOffers();
    } catch (e) {
      emit(OfferByIdFailedState(message: e.toString()));
    }
    return false;
  }

  @override
  Future<bool> updateOffers(
      {required String title,
      required String id,
      required int offerPercentage,
      required String startDate,
      required String endDate,
      required int status,
      required List<String> products,
      required List<String> customers}) async {
    try {
      final data = await offerInterface.updateOffers(
          title: title,
          id: id,
          offerPercentage: offerPercentage,
          startDate: startDate,
          endDate: endDate,
          status: status,
          products: products,
          customers: customers);
      if (data) {
        emit(OfferUpdateSuccessState());
      } else {
        emit(const OfferUpdateFailedState(message: 'Please Try Again'));
      }
      await getAllOffers();
    } catch (e) {
      emit(OfferUpdateFailedState(message: e.toString()));
    }
    return false;
  }

  // @override
  // Future<bool> updateOffers({required int id}) async {
  // try {
  //   final data = await offerInterface.updateOffers(id: id);
  //   if (data) {
  //     emit(OfferUpdateSuccessState());
  //   } else {
  //     emit(const OfferUpdateFailedState(message: 'Please Try Again'));
  //   }
  //   await getAllOffers();
  // } catch (e) {
  //   emit(OfferUpdateFailedState(message: e.toString()));
  // }
  // return false;
  // }
}

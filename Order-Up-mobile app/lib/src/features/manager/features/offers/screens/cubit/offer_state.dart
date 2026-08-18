import 'package:equatable/equatable.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/all_offers.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/new_customer_product.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/offers_by_id.dart';

abstract class OfferState extends Equatable {
  const OfferState();

  @override
  List<Object> get props => [];
}

class OfferCustomerProductInitialState extends OfferState {}

class OfferCustomerProductLoadingState extends OfferState {}

class OfferCustomerProductLoadedState extends OfferState {
  const OfferCustomerProductLoadedState({required this.productCustomerList});

  final ProductCustomer productCustomerList;
}

class OfferCustomerProductFailedState extends OfferState {
  const OfferCustomerProductFailedState({required this.message});

  final String message;
}

class AllOfferstLoadingState extends OfferState {}

class AllOffersLoadedState extends OfferState {
  const AllOffersLoadedState({required this.allOfferList});

  final AllOffers allOfferList;
}

class AllOffersFailedState extends OfferState {
  const AllOffersFailedState({required this.message});

  final String message;
}

class DeleteOfferstLoadingState extends OfferState {}

class DeleteOffersSuccessState extends OfferState {}

class DeleteOffersFailedState extends OfferState {
  const DeleteOffersFailedState({required this.message});

  final String message;
}

class OfferByIdLoadingState extends OfferState {}

class OfferByIdLoadedState extends OfferState {
  const OfferByIdLoadedState({required this.offerByIdList});

  final OffersById offerByIdList;
}

class OfferByIdFailedState extends OfferState {
  const OfferByIdFailedState({required this.message});

  final String message;
}

class OfferCreateLoadingState extends OfferState {}

class OfferCreateSuccessState extends OfferState {}

class OfferCreateFailedState extends OfferState {
  const OfferCreateFailedState({required this.message});

  final String message;
}

class OfferUpdateLoadingState extends OfferState {}

class OfferUpdateSuccessState extends OfferState {}

class OfferUpdateFailedState extends OfferState {
  const OfferUpdateFailedState({required this.message});

  final String message;
}

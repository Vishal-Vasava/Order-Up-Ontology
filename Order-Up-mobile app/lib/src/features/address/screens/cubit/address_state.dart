part of 'address_cubit.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitialState extends AddressState {}

class AddressLoadingState extends AddressState {}

class AddressLoadedState extends AddressState {
  const AddressLoadedState({
    required this.addressList,
    this.sourceAddressId,
    this.destinationAddressId,
  });

  final List<Address> addressList;
  final String? sourceAddressId;
  final String? destinationAddressId;

  AddressLoadedState copyWith({
    String? sourceAddressId,
    String? destinationAddressId,
  }) {
    return AddressLoadedState(
      addressList: addressList,
      sourceAddressId: sourceAddressId ?? this.sourceAddressId,
      destinationAddressId: destinationAddressId ?? this.destinationAddressId,
    );
  }
}

class AddressFailedState extends AddressState {
  const AddressFailedState({required this.message});

  final String message;
}

/// ADDRESS [ADD] State
class AddressAddLoadingState extends AddressState {}

class AddressAddSuccessState extends AddressState {}

class AddressAddFailedState extends AddressState {
  const AddressAddFailedState({required this.message});

  final String message;
}

/// ADDRESS [UPDATE] State
class AddressUpdateLoadingState extends AddressState {}

class AddressUpdateSuccessState extends AddressState {}

class AddressUpdateFailedState extends AddressState {
  const AddressUpdateFailedState({required this.message});

  final String message;
}

/// ADDRESS [DELETE] State
class AddressDeleteLoadingState extends AddressState {}

class AddressDeleteSuccessState extends AddressState {}

class AddressDeleteFailedState extends AddressState {
  const AddressDeleteFailedState({required this.message});

  final String message;
}

class AddressCheckLoadingState extends AddressState {}

class AddressCheckSuccessState extends AddressState {
  const AddressCheckSuccessState({required this.address});

  final String address;
}

class AddressCheckFailedState extends AddressState {
  const AddressCheckFailedState({required this.message});

  final String message;
}

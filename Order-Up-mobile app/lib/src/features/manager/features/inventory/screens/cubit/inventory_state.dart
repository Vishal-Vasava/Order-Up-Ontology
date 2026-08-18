part of 'inventory_cubit.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitialState extends InventoryState {}

/// GET INVENTORY LIST STATE
class InventoryLoadingState extends InventoryState {}

class InventoryLoadedState extends InventoryState {
  const InventoryLoadedState({
    required this.inventoryList,
    required this.searchInventoryList,
  });

  final List<InventoryItem> inventoryList;
  final List<InventoryItem> searchInventoryList;

  InventoryLoadedState copyWith({List<InventoryItem>? searchInventoryList}) {
    return InventoryLoadedState(
      inventoryList: inventoryList,
      searchInventoryList: searchInventoryList ?? this.searchInventoryList,
    );
  }
}

class InventorySearchState extends InventoryState {}

class InventoryFailedState extends InventoryState {
  const InventoryFailedState({required this.message});

  final String message;
}

class InventoryImagePickLoadingState extends InventoryState {}

class InventoryImagePickLoadedState extends InventoryState {
  const InventoryImagePickLoadedState({required this.pickedImage});

  final XFile? pickedImage;
}

class InventoryImagePickFailedState extends InventoryState {
  const InventoryImagePickFailedState({required this.message});

  final String message;
}

/// GET SKU GALLERY LIST STATE
class InventorySkuLoadingState extends InventoryState {
  const InventorySkuLoadingState(
      {required this.isFirstLoading, required this.galleryList});

  final bool isFirstLoading;
  final List<SkuGalleryItem> galleryList;
}

class InventorySkuLoadedState extends InventoryState {
  const InventorySkuLoadedState({
    required this.skuInventoryList,
    required this.searchSkuInventoryList,
    required this.pageCount,
  });

  final List<SkuGalleryItem> skuInventoryList;
  final List<SkuGalleryItem>? searchSkuInventoryList;
  final int? pageCount;
}

class InventorySkuFailedState extends InventoryState {
  const InventorySkuFailedState({required this.message});

  final String message;
}

/// INVENTORY ADD STATE
class InventoryAddLoadingState extends InventoryState {}

class InventoryAddSuccessState extends InventoryState {}

class InventoryAddFailedState extends InventoryState {
  const InventoryAddFailedState({required this.message});

  final String message;
}

/// INVENTORY UPDATE STATE
class InventoryUpdateLoadingState extends InventoryState {}

class InventoryUpdateSuccessState extends InventoryState {}

class InventoryUpdateFailedState extends InventoryState {
  const InventoryUpdateFailedState({required this.message});

  final String message;
}

/// INVENTORY DELETE STATE
class InventoryDeleteLoadingState extends InventoryState {}

class InventoryDeleteSuccessState extends InventoryState {}

class InventoryDeleteFailedState extends InventoryState {
  const InventoryDeleteFailedState({required this.message});

  final String message;
}

class InventoryReturnPolicyLoadingState extends InventoryState {}

class InventoryReturnPolicyLoadedState extends InventoryState {
  const InventoryReturnPolicyLoadedState({required this.productReasonList});

  final ProductReason productReasonList;
}

class InventoryReturnPolicyFailedState extends InventoryState {
  const InventoryReturnPolicyFailedState({required this.message});

  final String message;
}

class InventoryPickupLoadingState extends InventoryState {}

class InventoryPickupLoadedState extends InventoryState {
  const InventoryPickupLoadedState({required this.productEstimatesList});

  final PickupEstimates productEstimatesList;
}

class InventoryPickupFailedState extends InventoryState {
  const InventoryPickupFailedState({required this.message});

  final String message;
}

class InventoryCreateEstimatesLoadingState extends InventoryState {}

class InventoryCreateEstimatesLoadedState extends InventoryState {
  const InventoryCreateEstimatesLoadedState({required this.createEstimateData});

  final CreateEstimates createEstimateData;
}

class InventoryCreateEstimatesFailedState extends InventoryState {
  const InventoryCreateEstimatesFailedState({required this.message});

  final String message;
}

class InventoryFilterLoadingState extends InventoryState {}

class InventoryFilterLoadedState extends InventoryState {
  const InventoryFilterLoadedState({
    required this.filtersList,
  });

  final List<Filters> filtersList;

  InventoryFilterLoadedState copyWith({
    List<String>? selectedFiltersList,
  }) {
    return InventoryFilterLoadedState(
      filtersList: filtersList,
    );
  }
}

class InventoryFilterFailedState extends InventoryState {
  const InventoryFilterFailedState({required this.message});

  final String message;
}

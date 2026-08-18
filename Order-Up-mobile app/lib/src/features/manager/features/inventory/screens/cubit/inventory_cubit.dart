import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/data/inventory_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/create_estimates.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/pickup_estimates.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/product_reason.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/sku_gallery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory_model.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> implements InventoryAdapter {
  InventoryCubit({
    required this.inventoryAdapter,
  }) : super(InventoryInitialState());
  final InventoryAdapter inventoryAdapter;

  List<InventoryItem> inventoryList = [];

  String selectedPolicyValue = '';

  @override
  Future<Inventory?> getInventoryList({bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(InventoryLoadingState());
      }
      final data = await inventoryAdapter.getInventoryList();
      debugPrint(inject.get<AuthLocalRepository>().accessToken);
      if (data != null) {
        inventoryList = data.data;
        emit(InventoryLoadedState(
          inventoryList: inventoryList,
          searchInventoryList: const [],
        ));
      }
    } catch (e) {
      emit(InventoryFailedState(message: e.toString()));
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: e.toString(),
          );
    }
    return null;
  }

  int paginatedPage = 1;
  List<SkuGalleryItem> skuGalleryList = [];
  @override
  Future<SkuGallery?> getGalleryList({
    required String searchDish,
    required int pageNumber,
  }) async {
    try {
      emit(InventorySkuLoadingState(
        isFirstLoading: skuGalleryList.isEmpty,
        galleryList: skuGalleryList,
      ));
      final skuGallery = await inventoryAdapter.getGalleryList(
        searchDish: searchDish,
        pageNumber: pageNumber,
      );
      if (skuGallery != null) {
        skuGalleryList.addAll(skuGalleryList);
        emit(InventorySkuLoadedState(
          skuInventoryList: skuGallery.data.data,
          searchSkuInventoryList: null,
          pageCount: pageNumber,
        ));
        paginatedPage = pageNumber;
        paginatedPage++;
      } else {
        skuGalleryList.clear();
        paginatedPage = -1;
        log('END OF PAGINATION');
        emit(const InventorySkuFailedState(message: 'Please try again'));
      }
    } catch (e) {
      emit(InventorySkuFailedState(message: e.toString()));
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: e.toString(),
          );
    }
    return null;
  }

  void resetPagination() {
    paginatedPage = 1;
    emit(
      const InventorySkuLoadedState(
        skuInventoryList: [],
        searchSkuInventoryList: null,
        pageCount: 1,
      ),
    );
  }

  @override
  Future<bool> addInventory({required InventoryModel inventoryModel}) async {
    try {
      emit(InventoryAddLoadingState());
      final success =
          await inventoryAdapter.addInventory(inventoryModel: inventoryModel);
      if (success) {
        emit(InventoryAddSuccessState());
      } else {
        emit(const InventoryAddFailedState(message: 'Couldn\'t add Inventory'));
      }
      await getInventoryList(showLoading: false);
    } catch (e) {
      emit(InventoryAddFailedState(message: e.toString()));
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: e.toString(),
          );
    }
    return false;
  }

  @override
  Future<bool> editInventory({required InventoryModel inventoryModel}) async {
    try {
      emit(InventoryUpdateLoadingState());
      final success =
          await inventoryAdapter.editInventory(inventoryModel: inventoryModel);
      if (success) {
        emit(InventoryUpdateSuccessState());
      } else {
        emit(const InventoryUpdateFailedState(
            message: 'Couldn\'t add Inventory'));
      }
      await getInventoryList(showLoading: false);
    } catch (e) {
      emit(InventoryUpdateFailedState(message: e.toString()));
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: e.toString(),
          );
    }
    return false;
  }

  @override
  Future<bool> deleteInventory({required String productId}) async {
    try {
      emit(InventoryDeleteLoadingState());
      final success =
          await inventoryAdapter.deleteInventory(productId: productId);
      if (success) {
        emit(InventoryDeleteSuccessState());
      } else {
        emit(const InventoryDeleteFailedState(
            message: 'Couldn\'t add Inventory'));
      }
      await getInventoryList(showLoading: false);
    } catch (e) {
      emit(InventoryDeleteFailedState(message: e.toString()));
      inject.get<CrashService>().logError(
            exception: e,
            errorMessage: e.toString(),
          );
    }
    return false;
  }

  @override
  void searchInventory({required String searchText}) async {
    try {
      emit(InventorySearchState());
      if (searchText.isNotEmpty) {
        String search = searchText.toLowerCase();
        final List<InventoryItem> searchList = [];
        for (final value in inventoryList) {
          if (value.producer!.name!.toLowerCase().contains(search) ||
              value.price!.toString().toLowerCase().contains(search) ||
              value.name!.toLowerCase().contains(search) ||
              value.qty!.toString().contains(search) ||
              value.desc!.toLowerCase().contains(search)) {
            searchList.add(value);
          }
        }
        emit(InventoryLoadedState(
            inventoryList: inventoryList, searchInventoryList: searchList));
      } else {
        emit(InventoryLoadedState(
            inventoryList: inventoryList, searchInventoryList: const []));
      }
    } catch (e) {
      emit(InventoryFailedState(message: e.toString()));
    }
  }

  XFile? pickedImage;
  @override
  Future<XFile?> pickImage({
    required ImageSource imageSource,
  }) async {
    try {
      emit(InventoryImagePickLoadingState());
      final data = await inventoryAdapter.pickImage(imageSource: imageSource);
      pickedImage = data;
      emit(InventoryImagePickLoadedState(pickedImage: data));
    } on PlatformException catch (e) {
      emit(InventoryImagePickFailedState(message: e.toString()));
    } catch (e) {
      emit(InventoryImagePickFailedState(message: e.toString()));
    }
    return null;
  }

  @override
  Future<ProductReason?> getProductReason() async {
    try {
      emit(InventoryReturnPolicyLoadingState());
      final data = await inventoryAdapter.getProductReason();
      if (data != null) {
        emit(InventoryReturnPolicyLoadedState(productReasonList: data));
      } else {
        emit(const InventoryReturnPolicyFailedState(
            message: 'Please try again later'));
      }
    } catch (e) {
      emit(InventoryReturnPolicyFailedState(message: e.toString()));
    }
    return null;
  }

  @override
  Future<PickupEstimates?> getPickupEstimates() async {
    try {
      emit(InventoryPickupLoadingState());
      final data = await inventoryAdapter.getPickupEstimates();
      if (data != null) {
        emit(InventoryPickupLoadedState(productEstimatesList: data));
      } else {
        emit(const InventoryPickupFailedState(
            message: 'Please try again later'));
      }
    } catch (e) {
      emit(InventoryPickupFailedState(message: e.toString()));
    }
    return null;
  }

  @override
  Future<CreateEstimates?> createEstimates({
    required String title,
  }) async {
    try {
      emit(InventoryCreateEstimatesLoadingState());
      final data = await inventoryAdapter.createEstimates(
        title: title,
      );
      if (data != null) {
        emit(InventoryCreateEstimatesLoadedState(createEstimateData: data));
        getPickupEstimates();
      } else {
        emit(const InventoryCreateEstimatesFailedState(
            message: 'Please try again later'));
      }
    } catch (e) {
      emit(InventoryCreateEstimatesFailedState(message: e.toString()));
    }
    return null;
  }

  List<Filters> filtersList = [];

  @override
  Future<List<Filters>> getFilters() async {
    try {
      emit(InventoryFilterLoadingState());
      final data = await inventoryAdapter.getFilters();
      if (data.isNotEmpty) {
        filtersList = data;
        emit(InventoryFilterLoadedState(filtersList: filtersList));
      } else {
        emit(const InventoryFilterLoadedState(filtersList: []));
      }
    } catch (e) {
      emit(InventoryFilterFailedState(message: e.toString()));
    }
    return [];
  }

  void emitSelectedFilter(List<Filters> selectedFiltersList) {
    emit(InventoryFilterLoadingState());
    emit(InventoryFilterLoadedState(filtersList: selectedFiltersList));
  }
}

import 'package:image_picker/image_picker.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/create_estimates.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory_model.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/pickup_estimates.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/product_reason.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/sku_gallery.dart';

abstract class InventoryAdapter {
  Future<Inventory?> getInventoryList();

  Future<bool> addInventory({required InventoryModel inventoryModel});

  Future<bool> editInventory({required InventoryModel inventoryModel});

  Future<bool> deleteInventory({required String productId});

  Future<SkuGallery?> getGalleryList({
    required String searchDish,
    required int pageNumber,
  });

  void searchInventory({required String searchText}) {}

  Future<XFile?> pickImage({required ImageSource imageSource});

  Future<ProductReason?> getProductReason();

  Future<PickupEstimates?> getPickupEstimates();

  Future<CreateEstimates?> createEstimates({required String title});

  Future<List<Filters>> getFilters();
}

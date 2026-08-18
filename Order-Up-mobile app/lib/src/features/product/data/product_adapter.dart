import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/product/domain/banners.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';

abstract class ProductAdapter {
  /// `next_cursor` is for pagination
  Future<Product?> getProductList({
    required String storeId,
    required String nextCursor,
    required bool isRefresh,
    List<String>? filters,
  });

  Future<ProductData?> getProductDetail({required String productId});

  Future<List<Filters>> getFilters();
  Future<List<Banners>> getBanners();

  void resetPagination() => throw UnimplementedError('');

  void searchProduct({required String search});
}

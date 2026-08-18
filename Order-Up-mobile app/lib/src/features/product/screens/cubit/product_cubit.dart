import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/filters.dart';
import 'package:orderly_ecom/src/features/product/data/product_adapter.dart';
import 'package:orderly_ecom/src/features/product/domain/banners.dart';
import 'package:orderly_ecom/src/features/product/domain/product.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> implements ProductAdapter {
  ProductCubit({required this.productAdapter}) : super(ProductInitialState());
  final ProductAdapter productAdapter;

  String nextCursorPagination = '';
  List<ProductData> paginatedData = <ProductData>[];

  @override
  Future<Product?> getProductList({
    required String storeId,
    required String nextCursor,
    required bool isRefresh,
    List<String>? filters,
  }) async {
    try {
      // if (state is ProductLoadedState) {
      //   oldData = (state as ProductLoadedState).productList;
      // }

      if (isRefresh) {
        endPagination = false;
      }

      // if (!endPagination && !isRefresh) {
      //   // Substracting offset because it is incremented in the api on categorylist
      // } else {
      //   oldData.clear();
      //   nextCursorPagination = '';
      // }
      if (nextCursorPagination.isNotEmpty) {
        emit(const ProductPaginateLoadingState());
      } else {
        paginatedData.clear();
        emit(const ProductLoadingState());
      }

      final product = await productAdapter.getProductList(
        storeId: storeId,
        nextCursor: nextCursorPagination,
        isRefresh: false,
        filters: selectedFiltersList,
      );
      if (product != null) {
        if (product.nextCursor!.isEmpty) {
          log('End of Pagination');
          endPagination = true;
          nextCursorPagination = '';
        } else {
          nextCursorPagination = product.nextCursor!;
        }
        paginatedData = paginatedData + (product.productList ?? []);
        emit(ProductLoadedState(
          productList: paginatedData,
          endPagination: endPagination,
          searchedProductList: const [],
        ));
      }
    } catch (e) {
      emit(ProductFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
    }
    return null;
  }

  bool endPagination = false;

  @override
  void resetPagination() {
    endPagination = false;
  }

  @override
  Future<ProductData?> getProductDetail({required String productId}) async {
    try {
      emit(ProductDetailLoadingState());
      final product =
          await productAdapter.getProductDetail(productId: productId);
      if (product != null) {
        emit(ProductDetailLoadedState(product: product));
      } else {
        emit(const ProductDetailFailedState(message: 'No product found'));
      }
    } catch (e) {
      emit(ProductDetailFailedState(message: e.toString()));
    }
    return null;
  }

  List<Filters> filtersList = [];
  List<String> selectedFiltersList = [];
  void resetFilterList() {
    selectedFiltersList = [];
  }

  @override
  Future<List<Filters>> getFilters() async {
    try {
      emit(ProductFiltersLoadingState());
      final data = await productAdapter.getFilters();
      if (data.isNotEmpty) {
        filtersList = data;
        emit(ProductFiltersLoadedState(filtersList: data));
      } else {
        emit(const ProductFiltersLoadedState(filtersList: []));
      }
    } catch (e) {
      emit(ProductFiltersFailedState(message: e.toString()));
    }
    return [];
  }

  void emitSelectedFilter() {
    emit(ProductFiltersLoadingState());
    emit(ProductFiltersLoadedState(filtersList: filtersList));
  }

  @override
  Future<List<Banners>> getBanners() async {
    try {
      emit(ProductBannerLoadingState());
      final data = await productAdapter.getBanners();
      if (data.isNotEmpty) {
        emit(ProductBannerLoadedState(bannerList: data));
      } else {
        emit(const ProductBannerLoadedState(bannerList: []));
      }
    } catch (e) {
      emit(ProductBannerFailedState(message: e.toString()));
    }
    return [];
  }

  @override
  void searchProduct({required String search}) {
    List<ProductData> searchList = [];
    final searchTerm = search.toLowerCase();
    try {
      emit(const ProductLoadingState());
      if (searchTerm.isEmpty) {
        emit(
          ProductLoadedState(
            productList: paginatedData,
            searchedProductList: searchList,
            endPagination: endPagination,
          ),
        );
        return;
      }
      for (final item in paginatedData) {
        if (item.name!.toLowerCase().contains(searchTerm) ||
            item.desc!.toLowerCase().contains(searchTerm)) {
          searchList.add(item);
        }
      }
      emit(
        ProductLoadedState(
          productList: paginatedData,
          searchedProductList: searchList,
          endPagination: endPagination,
        ),
      );
    } catch (e) {
      emit(ProductSearchFailedState(message: e.toString()));
    }
  }
}

part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

/// PRODUCT STATE
class ProductLoadingState extends ProductState {
  const ProductLoadingState();
}

class ProductPaginateLoadingState extends ProductState {
  const ProductPaginateLoadingState();
}

class ProductIdUpdateState extends ProductState {}

class ProductLoadedState extends ProductState {
  const ProductLoadedState({
    required this.productList,
    required this.searchedProductList,
    required this.endPagination,
  });

  final List<ProductData> productList;
  final List<ProductData> searchedProductList;
  final bool endPagination;

  ProductLoadedState copyWith({List<ProductData>? searchedProductList}) {
    return ProductLoadedState(
      productList: productList,
      searchedProductList: searchedProductList ?? this.searchedProductList,
      endPagination: endPagination,
    );
  }
}

class ProductFailedState extends ProductState {
  const ProductFailedState({required this.message});

  final String message;
}

class ProductSearchFailedState extends ProductState {
  const ProductSearchFailedState({required this.message});

  final String message;
}

class ProductDetailLoadingState extends ProductState {}

class ProductDetailLoadedState extends ProductState {
  const ProductDetailLoadedState({required this.product});

  final ProductData product;
}

class ProductDetailFailedState extends ProductState {
  const ProductDetailFailedState({required this.message});

  final String message;
}

class ProductFiltersLoadingState extends ProductState {}

class ProductFiltersLoadedState extends ProductState {
  const ProductFiltersLoadedState({required this.filtersList});

  final List<Filters> filtersList;
}

class ProductFiltersFailedState extends ProductState {
  const ProductFiltersFailedState({required this.message});

  final String message;
}

class ProductBannerLoadingState extends ProductState {}

class ProductBannerLoadedState extends ProductState {
  const ProductBannerLoadedState({required this.bannerList});

  final List<Banners> bannerList;
}

class ProductBannerFailedState extends ProductState {
  const ProductBannerFailedState({required this.message});

  final String message;
}

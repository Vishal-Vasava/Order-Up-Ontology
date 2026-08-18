import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/category/data/category_adapter.dart';
import 'package:orderly_ecom/src/features/category/domain/category.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> implements CategoryAdapter {
  CategoryCubit({required this.categoryAdapter})
      : super(CategoryInitialState());
  final CategoryAdapter categoryAdapter;

  List<Category> categoryList = [];

  @override
  Future<List<Category>> getCategoryList({
    required String custLat,
    required String custLong,
    bool isRefresh = false,
  }) async {
    try {
      /// TO AVOID API CALL
      if (state is CategoryLoadedState && !isRefresh) {
        return [];
      }
      emit(CategoryLoadingState());
      final list = await categoryAdapter.getCategoryList(
          custLat: custLat, custLong: custLong);
      categoryList = list;
      emit(CategoryLoadedState(
        categoryList: categoryList,
        selectedCategoryIndex: 0,
      ));
    } catch (e) {
      emit(CategoryFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
    }
    return [];
  }

  int categoryIndex = 0;
  void updateCategoryId({required int categoryIndex}) {
    emit(CategoryIdUpdateState());
    emit(CategoryLoadedState(
        categoryList: categoryList, selectedCategoryIndex: categoryIndex));
    this.categoryIndex = categoryIndex;
  }
}

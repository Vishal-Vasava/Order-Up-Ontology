part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitialState extends CategoryState {}

/// CATEGORY STATE
class CategoryLoadingState extends CategoryState {}

class CategoryIdUpdateState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  const CategoryLoadedState({
    required this.categoryList,
    required this.selectedCategoryIndex,
  });

  final List<Category> categoryList;
  final int selectedCategoryIndex;

  CategoryLoadedState copyWith({int? selectedCategoryIndex}) {
    return CategoryLoadedState(
      categoryList: categoryList,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}

class CategoryFailedState extends CategoryState {
  const CategoryFailedState({required this.message});

  final String message;
}

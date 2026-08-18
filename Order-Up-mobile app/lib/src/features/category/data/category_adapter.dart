import 'package:orderly_ecom/src/features/category/domain/category.dart';

abstract class CategoryAdapter {
  Future<List<Category>> getCategoryList({
    required String custLat,
    required String custLong,
  });
}

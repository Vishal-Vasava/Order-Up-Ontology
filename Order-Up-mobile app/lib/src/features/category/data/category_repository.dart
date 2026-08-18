import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/category/data/category_adapter.dart';
import 'package:orderly_ecom/src/features/category/domain/category.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class CategoryRepository extends CategoryAdapter {
  CategoryRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;

  @override
  Future<List<Category>> getCategoryList({
    required String custLat,
    required String custLong,
  }) async {
    try {
      const String url = Endpoints.findStores;
      final data = {'latitude': custLat, 'longitude': custLong};
      // final data = {'latitude': '18.5125', 'longitude': '73.8612'};
      final response = await networkAdapter.post(
        url,
        data: data,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if ((response.data['data'] as List).isEmpty) {
          throw const AppException(message: 'No result found');
        }
        return (response.data['data'] as List)
            .map((e) => Category.fromJson(e))
            .toList();
      } else {
        throw const AppException(message: 'Couldn\'t fetch orders');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
}

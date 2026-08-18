import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/data/customer_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/domain/customer_list.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/utils/exceptions.dart';

class CustomerListRepository extends CustomerAdapter {
  CustomerListRepository({required this.networkAdapter});

  final NetworkAdapter networkAdapter;
  @override
  Future<List<CustomerList>> getCustomerList({required int page}) async {
    try {
      const String url = Endpoints.storeCustomers;
      // final data = {'page': page};
      final response = await networkAdapter.post(
        url,
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        if (response.data['statusCode'] == 200) {
          return List<CustomerList>.from(response.data['data']
                  ['customer_details']
              .map((x) => CustomerList.fromJson(x)));
        } else {
          return [];
        }
      } else {
        throw const AppException(message: 'Please try again');
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}

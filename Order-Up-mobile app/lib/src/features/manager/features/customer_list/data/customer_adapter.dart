import 'package:orderly_ecom/src/features/manager/features/customer_list/domain/customer_list.dart';

abstract class CustomerAdapter {
  Future<List<CustomerList>> getCustomerList({required int page});
}

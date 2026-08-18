import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/data/customer_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/domain/customer_list.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'customer_list_state.dart';

class CustomerListCubit extends Cubit<CustomerListState>
    implements CustomerAdapter {
  CustomerListCubit({required this.customerAdapter})
      : super(CustomerListInitialState());
  final CustomerAdapter customerAdapter;

  @override
  Future<List<CustomerList>> getCustomerList({required int page}) async {
    try {
      emit(CustomerListLoadingState());
      final data = await customerAdapter.getCustomerList(page: page);
      emit(CustomerListLoadedState(customerList: data));
    } catch (e) {
      emit(CustomerListFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString());
    }
    return [];
  }
}

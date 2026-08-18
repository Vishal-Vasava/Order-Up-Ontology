import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/data/customer_list_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/screens/cubit/customer_list_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/screens/customer_list_widget.dart';
import 'package:orderly_ecom/src/features/manager/widgets/manager_app_bar.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CustomerListRepository(
        networkAdapter: inject.get<NetworkAdapter>(),
      ),
      child: BlocProvider(
        create: (context) => CustomerListCubit(
          customerAdapter: context.read<CustomerListRepository>(),
        )..getCustomerList(page: 1),
        child: BlocBuilder<CustomerListCubit, CustomerListState>(
          buildWhen: (oldState, _) {
            return oldState is CustomerListInitialState;
          },
          builder: (context, state) {
            return Scaffold(
              appBar: ManagerAppBar(
                title: AppLocalizations.of(context)!.customers,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<CustomerListCubit>().getCustomerList(page: 1);
                },
                child: const CustomerListWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}

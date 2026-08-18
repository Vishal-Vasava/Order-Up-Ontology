import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/customer_list/screens/cubit/customer_list_cubit.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class CustomerListWidget extends StatelessWidget {
  const CustomerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerListCubit, CustomerListState>(
      buildWhen: (_, newState) {
        return newState is CustomerListFailedState ||
            newState is CustomerListLoadedState ||
            newState is CustomerListLoadingState;
      },
      builder: (context, state) {
        if (state is CustomerListFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is CustomerListLoadingState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  ...List.generate(
                    4,
                    (index) => const AppShimmer(
                      height: 100.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CustomerListLoadedState) {
          if (state.customerList.isEmpty) {
            return const Center(
              child: DefaultErrorScreen(
                message: 'No Data Yet!',
              ),
            );
          }
          return ListView.separated(
            itemCount: state.customerList.length,
            separatorBuilder: (c, i) {
              return const Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                visualDensity: VisualDensity.compact,
                title: Text(
                  '${state.customerList[index].firstName} ${state.customerList[index].lastName}',
                ),
                subtitle: Text(
                  state.customerList[index].phone,
                ),
                trailing: Column(
                  children: [
                    Text(
                      '${state.customerList[index].currency[0].locale!.getCurrencyPerLocale} ${state.customerList[index].orderSum}',
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

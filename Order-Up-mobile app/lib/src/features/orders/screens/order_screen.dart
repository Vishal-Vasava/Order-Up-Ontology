import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/customer/widgets/customer_app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/order_list.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/order_search_filter.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<OrderCubit>().getOrderList(
            timeType: '',
            duration: '',
            status: 'pending',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerAppBar(
        title: AppLocalizations.of(context)!.orders,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderSearchFilter(),
          gapH12,
          OrderList(),
        ],
      ),
    );
  }
}

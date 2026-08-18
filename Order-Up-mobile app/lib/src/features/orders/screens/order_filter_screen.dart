import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';

class OrderFilterScreen extends StatefulWidget {
  const OrderFilterScreen({super.key});

  @override
  _OrderFilterScreenState createState() => _OrderFilterScreenState();
}

class _OrderFilterScreenState extends State<OrderFilterScreen> {
  List orderTimeList(BuildContext context) => [
        AppLocalizations.of(context)!.last30days,
        AppLocalizations.of(context)!.last60days,
        AppLocalizations.of(context)!.year_2020,
        AppLocalizations.of(context)!.year_2021,
        AppLocalizations.of(context)!.older,
      ];
  List orderStatusList(BuildContext context) => [
        AppLocalizations.of(context)!.accepted,
        AppLocalizations.of(context)!.shipped,
        AppLocalizations.of(context)!.delivered,
      ];

  final ValueNotifier<int> selectedOrderTime = ValueNotifier<int>(0);
  final ValueNotifier<String> selectedOrderTimeValue =
      ValueNotifier<String>('Last 30 days');

  final ValueNotifier<int> selectedOrderStatus = ValueNotifier<int>(0);
  final ValueNotifier<String> selectedOrderStatusValue =
      ValueNotifier<String>('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.filter,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          gapH12,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: kBorderRadius),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 20,
                  spreadRadius: -10,
                  color: AppColor.kShadowColor,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Text(
                    'Order Time ${AppLocalizations.of(context)!.filter}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...List.generate(
                  orderTimeList(context).length,
                  (index) {
                    return ValueListenableBuilder(
                      valueListenable: selectedOrderTime,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return RadioListTile(
                          activeColor: Theme.of(context).primaryColor,
                          value: index,
                          groupValue: value,
                          title: Text(
                            orderTimeList(context)[index],
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onChanged: (int? value) {
                            selectedOrderTime.value = value!;
                            selectedOrderTimeValue.value =
                                orderTimeList(context)[index];
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          gapH12,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 20,
                  spreadRadius: -10,
                  color: AppColor.kShadowColor,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Text(
                    'Order Status ${AppLocalizations.of(context)!.filter}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...List.generate(
                  orderStatusList(context).length,
                  (index) {
                    return ValueListenableBuilder(
                      valueListenable: selectedOrderStatus,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return RadioListTile(
                          activeColor: Theme.of(context).primaryColor,
                          value: index,
                          groupValue: value,
                          title: Text(
                            orderStatusList(context)[index],
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          onChanged: (int? value) {
                            selectedOrderStatus.value = value!;
                            selectedOrderStatusValue.value =
                                orderStatusList(context)[index];
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: AppButton(
              onPressed: () async {
                String timeType = '';
                String duration = '';
                switch (selectedOrderTime.value) {
                  case 0:
                    timeType = 'days';
                    duration = '30';
                    break;
                  case 1:
                    timeType = 'days';
                    duration = '60';
                    break;
                  case 2:
                    timeType = 'year';
                    duration = '2020';
                    break;
                  case 3:
                    timeType = 'year';
                    duration = '2021';
                    break;
                  case 4:
                    timeType = 'older';
                    duration = '2021';
                    break;
                  default:
                }
                context.pop();
                await context.read<OrderCubit>().getOrderList(
                      timeType: timeType,
                      duration: duration,
                      status: 'pending',
                      // status: selectedOrderStatus.value + 1,
                    );
              },
              isLoading: false,
              buttonText: AppLocalizations.of(context)!.submit,
            ),
          ),
        ],
      ),
    );
  }
}

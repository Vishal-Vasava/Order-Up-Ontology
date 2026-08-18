import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/cubit/manager_order_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';

class OrderCancelSheet extends StatefulWidget {
  const OrderCancelSheet({
    super.key,
    required this.orderDetailIds,
    required this.orderStatus,
    required this.reasonList,
  });
  final List<String> orderDetailIds;
  final String orderStatus;
  final List<String> reasonList;

  @override
  State<OrderCancelSheet> createState() => _OrderCancelSheetState();
}

class _OrderCancelSheetState extends State<OrderCancelSheet> {
  final ValueNotifier<bool> isOther = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedReason = ValueNotifier<String>('');

  late TextEditingController reasonController;

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        kDefaultPadding,
        kDefaultPadding,
        kDefaultPadding,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: kDefaultPadding,
          right: kDefaultPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 60.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: AppColor.greyColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pop();
                  },
                  child: Icon(
                    kIsWeb ? Icons.close_rounded : Iconsax.close_square,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: kBorderRadius),
              child: Text(
                'Select Cancel Reason'.hardcoded,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            gapH12,
            ValueListenableBuilder(
              valueListenable: selectedReason,
              builder: (BuildContext context, String value, Widget? child) {
                return ListBody(
                  children: [
                    ...List.generate(
                      widget.reasonList.length,
                      (index) => RadioListTile<String>(
                        groupValue: value,
                        value: widget.reasonList[index],
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          widget.reasonList[index],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        onChanged: (String? reason) {
                          selectedReason.value = reason!;
                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          selectedReason.notifyListeners();
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (value == 'Other')
                      TextField(
                        controller: reasonController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.input_reason,
                          labelText: AppLocalizations.of(context)!.input_reason,
                        ),
                      ),
                  ],
                );
              },
            ),
            gapH8,
            AppButton(
              isLoading: false,
              buttonText: AppLocalizations.of(context)!.submit,
              onPressed: () async {
                if (selectedReason.value == 'Other' &&
                    reasonController.text.isEmpty) {
                  showSnackBar(
                    context: context,
                    title: 'Please Enter',
                    message: 'Valid reason',
                    positionTop: true,
                    snackbarType: SnackbarType.error,
                  );
                  return;
                } else if (selectedReason.value.isEmpty) {
                  showSnackBar(
                    context: context,
                    title: 'Please Select',
                    message: 'Valid reason!',
                    positionTop: true,
                    snackbarType: SnackbarType.error,
                  );
                  return;
                }
                final checkedList = context
                    .read<ManagerOrderCubit>()
                    .managerOrderDetail
                    ?.orderItems!
                    .where((element) => element.isChecked);
                List<String> orderDetailId = [];
                for (final item in checkedList!.toList()) {
                  orderDetailId.add(item.id!);
                }
                String orderStatus = widget.orderStatus;
                context.pop();

                await context.read<ManagerOrderCubit>().updateOrderStatus(
                      orderDetailId: orderDetailId,
                      orderStatus: orderStatus,
                      reason: selectedReason.value == 'Other'
                          ? reasonController.text.trim()
                          : selectedReason.value,
                    );
              },
            ),
            gapH12,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class OrderStatusDropdown extends StatefulWidget {
  const OrderStatusDropdown({
    super.key,
    required this.orderStatus,
    required this.onChanged,
  });
  final String orderStatus;
  final Function(String) onChanged;
  @override
  _OrderStatusDropdownState createState() => _OrderStatusDropdownState();
}

class _OrderStatusDropdownState extends State<OrderStatusDropdown> {
  final ValueNotifier<String> statusNotifier = ValueNotifier<String>('');

  List<_DropDownItem> orderStatusList = [];

  bool showButton = true;
  @override
  void initState() {
    super.initState();
    _populateOrderStatusList();
    if (widget.orderStatus != 'delivered' &&
        widget.orderStatus != 'returned' &&
        widget.orderStatus != 'cancelled' &&
        widget.orderStatus != 'rejected' &&
        widget.orderStatus != 'rejected' &&
        widget.orderStatus != 'returned' &&
        widget.orderStatus != 'shipped') {
      showButton = true;
    }
  }

  void _populateOrderStatusList() {
    if (widget.orderStatus == 'pending') {
      statusNotifier.value = 'confirmed'.hardcoded;
      orderStatusList
          .add(_DropDownItem(orderStatus: 'confirmed', statusName: 'Ready'));
      orderStatusList
          .add(_DropDownItem(orderStatus: 'shipped', statusName: 'Shipped'));
      orderStatusList
          .add(_DropDownItem(orderStatus: 'cancelled', statusName: 'Cancel'));
    } else if (widget.orderStatus == 'confirmed') {
      statusNotifier.value = 'shipped';
      orderStatusList
          .add(_DropDownItem(orderStatus: 'shipped', statusName: 'Shipped'));
      orderStatusList
          .add(_DropDownItem(orderStatus: 'cancelled', statusName: 'Cancel'));
    } else if (widget.orderStatus == 'returned') {
      statusNotifier.value = 'returned';
      orderStatusList.add(_DropDownItem(
          orderStatus: 'returned', statusName: 'Return Confirmed'));
      orderStatusList.add(_DropDownItem(
          orderStatus: 'rejected', statusName: 'Return Rejected'));
    } else if (widget.orderStatus == 'return_requested') {
      statusNotifier.value = 'return_conformed';
      orderStatusList.add(_DropDownItem(
          orderStatus: 'return_conformed', statusName: 'Return Confirmed'));
      orderStatusList.add(_DropDownItem(
          orderStatus: 'rejected', statusName: 'Return Rejected'));
    } else if (widget.orderStatus == 'replace_requested') {
      statusNotifier.value = 'replace_conformed';
      orderStatusList.add(_DropDownItem(
          orderStatus: 'replace_conformed', statusName: 'Replace Confirmed'));
      orderStatusList.add(_DropDownItem(
          orderStatus: 'rejected', statusName: 'Replace Rejected'));
    }
    // else if (widget.orderStatus == '5') {
    //   statusNotifier.value = '11';
    //   orderStatusList.add(
    //       _DropDownItem(orderStatus: '11', statusName: 'Replace Confirmed'));
    //   orderStatusList.add(_DropDownItem(
    //       orderStatus: 'rejected', statusName: 'Replace Rejected'));
    // }
    else if (widget.orderStatus == 'returned') {
      statusNotifier.value = 'rejected';
      orderStatusList.add(_DropDownItem(
          orderStatus: 'refundProcess', statusName: 'Return Shipped'));
      orderStatusList.add(_DropDownItem(
          orderStatus: 'returned', statusName: 'Return Delivered'));
      orderStatusList.add(_DropDownItem(
          orderStatus: 'rejected', statusName: 'Return Rejected'));
    } else if (widget.orderStatus == 'refundProcess') {
      statusNotifier.value = 'returned';
      orderStatusList.add(_DropDownItem(
          orderStatus: 'returned', statusName: 'Return Delivered'));
    }
    //  else if (widget.orderStatus == '11') {
    //   statusNotifier.value = '13';
    //   orderStatusList
    //       .add(_DropDownItem(orderStatus: '13', statusName: 'Replace Shipped'));
    //   orderStatusList.add(
    //       _DropDownItem(orderStatus: '14', statusName: 'Replace Delivered'));
    //   orderStatusList.add(_DropDownItem(
    //       orderStatus: 'rejected', statusName: 'Replace Rejected'));
    // } else if (widget.orderStatus == '13') {
    //   statusNotifier.value = 'Replace Delivered';
    //   orderStatusList.add(
    //       _DropDownItem(orderStatus: '14', statusName: 'Replace Delivered'));
    // }
  }

  @override
  Widget build(BuildContext context) {
    widget.onChanged(statusNotifier.value);
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.only(right: 10.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor.lightAccentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppColor.scaleGreyColor,
          ), //custom color
          child: ValueListenableBuilder(
            valueListenable: statusNotifier,
            builder: (BuildContext context, String value, Widget? child) {
              return ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  itemHeight: 50,
                  menuMaxHeight: 300.0,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select one status';
                    }
                    if (value.isEmpty) {
                      return 'Please select one status';
                    }
                    return null;
                  },
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  icon: const Icon(
                    kIsWeb
                        ? Icons.arrow_circle_down
                        : Iconsax.arrow_circle_down,
                    size: 20.0,
                    color: AppColor.blackColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.transparent,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Please Select Category'.hardcoded,
                  ),
                  value: value.isEmpty ? null : value,
                  onChanged: (data) {
                    statusNotifier.value = data!;
                    widget.onChanged.call(statusNotifier.value);
                  },
                  items: orderStatusList.map<DropdownMenuItem>(
                    (value) {
                      return DropdownMenuItem(
                        value: value.orderStatus,
                        child: Text(
                          value.statusName,
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DropDownItem {
  _DropDownItem({
    required this.orderStatus,
    required this.statusName,
  });

  final String orderStatus;
  final String statusName;
}

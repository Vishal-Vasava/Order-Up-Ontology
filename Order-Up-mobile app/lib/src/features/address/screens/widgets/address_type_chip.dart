import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class AddressTypeChip extends StatelessWidget {
  const AddressTypeChip({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final bool isSelected;
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: isSelected ? AppColor.primaryColor : Colors.white,
        child: Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: isSelected ? AppColor.whiteColor : AppColor.greyColor,
                size: 24,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColor.whiteColor : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

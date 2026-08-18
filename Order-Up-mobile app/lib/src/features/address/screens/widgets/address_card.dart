import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.modelData,
    required this.selectedAddressId,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.showButton,
  });
  final Address modelData;
  final String selectedAddressId;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showButton;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 300.0,
        padding: const EdgeInsets.all(kDefaultPadding),
        margin: const EdgeInsets.all(kBorderRadius),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: selectedAddressId == modelData.id
              ? Border.all(
                  color: AppColor.accentColor,
                )
              : null,
          boxShadow: const [
            BoxShadow(
              color: AppColor.scaleGreyColor,
              spreadRadius: 4.5,
              blurRadius: 4.5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${modelData.firstName!} ${modelData.lastName}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  gapH8,
                  Text(
                    modelData.address ?? '',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  gapH8,
                  Text(
                    'Mobile: ${modelData.phone ?? ''}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  gapH8,
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                kIsWeb ? Icons.edit : Iconsax.edit,
              ),
            ),
            if (showButton)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  kIsWeb ? Icons.delete : Iconsax.trash,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

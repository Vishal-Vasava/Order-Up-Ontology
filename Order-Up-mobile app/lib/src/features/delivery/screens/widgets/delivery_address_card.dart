// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/address/domain/address.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter/services.dart';

class DeliveryAddressCard extends StatelessWidget {
  const DeliveryAddressCard({
    super.key,
    required this.modelData,
    required this.title,
  });
  final Address modelData;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(12.0),
        initiallyExpanded:
            title.toLowerCase().contains('destination') ? true : false,
        maintainState: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              kIsWeb ? Icons.location_on : Iconsax.location,
              color: AppColor.accentColor,
            ),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 2.0,
                color: AppColor.accentColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    modelData.firstName ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      var uri = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${modelData.latitude},${modelData.longitude}');
                      if (await url_launcher.canLaunchUrl(uri)) {
                        await url_launcher.launchUrl(uri);
                      } else {
                        throw 'Could not launch ${uri.toString()}';
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          kIsWeb ? Icons.map : Iconsax.map,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'View In Map',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10.0),
              Text(
                modelData.email ?? '',
              ),
              const SizedBox(width: 10.0),
              RichText(
                text: TextSpan(
                  text: 'Mobile - ',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: modelData.phone,
                      style: Theme.of(context).textTheme.bodyLarge,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await url_launcher
                              .launchUrl(Uri.parse('tel://${modelData.phone}'));
                        },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    kIsWeb ? Icons.location_on : Iconsax.location,
                    size: 20.0,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      modelData.address ?? '',
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: modelData.address ?? '',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          margin: EdgeInsets.all(6),
                          backgroundColor: AppColor.primaryColor,
                          behavior: SnackBarBehavior.floating,
                          content: Text('Address Copied to Clipboard'),
                          duration: Duration(milliseconds: 3000),
                        ),
                      );
                    },
                    icon: const Icon(
                      kIsWeb ? Icons.copy : Iconsax.copy,
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Text(
                    modelData.houseNo?.toString() ?? '',
                  ),
                  gapW8,
                  Text(
                    modelData.street ?? '',
                  ),
                  gapW8,
                  Text(
                    modelData.city ?? '',
                  ),
                  gapW8,
                  Text(modelData.state ?? ''),
                  gapW8,
                  Text(
                    modelData.country ?? '',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

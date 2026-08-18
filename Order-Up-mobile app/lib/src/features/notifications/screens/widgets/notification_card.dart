import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/features/notifications/domain/notification_model.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.onDelete,
    required this.modelData,
  });
  final NotificationModel modelData;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColor.kShadowColor,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  modelData.title ?? '',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColor.textColor,
                      ),
                ),
              ),
              CircleAvatar(
                radius: 18.0,
                backgroundColor: AppColor.primaryColor.withOpacity(0.3),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onDelete,
                  icon: const Center(
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            modelData.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          if (modelData.bannerUrl?.isNotEmpty ?? false)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: modelData.bannerUrl ?? '',
                  memCacheHeight: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/notifications/screens/components/notification_list.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController = RefreshController();
    context.read<NotificationCubit>().getNotification();
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.notification,
      ),
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          await context.read<NotificationCubit>().getNotification();
          refreshController.refreshCompleted();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: const [
            NotificationList(),
          ],
        ),
      ),
    );
  }
}

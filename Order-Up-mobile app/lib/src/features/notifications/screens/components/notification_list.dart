import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/screens/widgets/notification_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (_, newState) {
        return newState is NotificationLoadingState ||
            newState is NotificationFailedState ||
            newState is NotificationLoadedState;
      },
      builder: (context, state) {
        if (state is NotificationLoadingState) {
          return ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10,
                              width: 180,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Container(
                              height: 10,
                              width: 150,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 6,
          );
        }
        if (state is NotificationFailedState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is NotificationLoadedState) {
          if (state.notificationList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.empty_notification,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            itemCount: state.notificationList.length,
            itemBuilder: (c, i) {
              return NotificationCard(
                modelData: state.notificationList[i],
                onDelete: () async {
                  await context.read<NotificationCubit>().deleteNotification(
                        notificationId: state.notificationList[i].id.toString(),
                      );
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

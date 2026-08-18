import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/config/config.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/data/auth_local_repository.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_user.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/screens/cubit/notification_cubit.dart';
import 'package:orderly_ecom/src/features/manager/widgets/manager_app_bar.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static bool _isGuestUser = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
        shadowColor: AppColor.whiteColor50,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (oldState, newState) {
              return newState is NotificationLoadedState;
            },
            builder: (context, state) {
              if (state is NotificationLoadedState) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(AppRoute.notificationScreen.toName);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        kIsWeb ? Icons.notifications : Iconsax.notification,
                      ),
                      Positioned(
                        right: -5,
                        top: 15,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: AppColor.accentColor,
                            borderRadius: BorderRadius.circular(8.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 17,
                            minHeight: 4,
                          ),
                          child: Text(
                            () {
                              return state.notificationList.length.toString();
                            }(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Offstage();
            },
          ),
          TextButton(
            onPressed: () {
              context.pushNamed(AppRoute.editProfile.toName);
            },
            child: Text(
              AppLocalizations.of(context)!.edit,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(kBorderRadius),
        children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.primaryColor, // red as border color
                      ),
                      color: Colors.white,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: inject
                          .get<AuthLocalRepository>()
                          .userBox
                          .listenable(),
                      builder: (BuildContext context, Box<AuthUser> value,
                          Widget? child) {
                        if (inject
                                    .get<AuthLocalRepository>()
                                    .authUser
                                    .imageUrl ==
                                null ||
                            inject
                                .get<AuthLocalRepository>()
                                .authUser
                                .imageUrl!
                                .isEmpty) {
                          return const ClipRect(
                            child: Icon(
                              kIsWeb ? Icons.person : Iconsax.user,
                            ),
                          );
                        }
                        return ClipRect(
                          child: ImageBuilder(
                            imageUrl: inject
                                .get<AuthLocalRepository>()
                                .authUser
                                .imageUrl!,
                            height: 100.0,
                            fitType: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gapH8,
                ValueListenableBuilder(
                  valueListenable:
                      inject.get<AuthLocalRepository>().userBox.listenable(),
                  builder: (BuildContext context, Box<AuthUser> value,
                      Widget? child) {
                    // bool isGuestUser = false;
                    // if (inject.get<HiveService>().guestAccessToken.isNotEmpty) {
                    //   isGuestUser = true;
                    // } else {
                    //   isGuestUser = false;
                    // }
                    return Text(
                      () {
                        // if (isGuestUser) {
                        // return 'Guest';
                        // } else {
                        return value.values.elementAt(0).fbId != null
                            ? value.values.elementAt(0).userType ==
                                    AuthRole.producer.name
                                ? 'Store manager: ${value.values.elementAt(0).firstName ?? ''} ${value.values.elementAt(0).lastName ?? ''}'
                                : '${value.values.elementAt(0).firstName ?? ''} ${value.values.elementAt(0).lastName ?? ''}'
                            : '';
                        // }
                      }(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: AppColor.textColor,
                      ),
                    );
                  },
                ),
                if (inject.get<AuthLocalRepository>().authUser.userType ==
                    AuthRole.producer.name)
                  StoreNameText(
                    prefix: 'Store: ',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                // ValueListenableBuilder(
                //   valueListenable:
                //       inject.get<AuthLocalRepository>().userBox.listenable(),
                //   builder: (BuildContext context, Box<AuthUser> value,
                //       Widget? child) {
                //     {
                //       return Text(
                //         inject
                //             .get<AuthLocalRepository>()
                //             .authUser
                //             .emailId
                //             .toString(),
                //         style: const TextStyle(
                //           fontWeight: FontWeight.w200,
                //           fontSize: 12.0,
                //           color: AppColor.textColor,
                //         ),
                //       );
                //     }
                //   },
                // ),
                ValueListenableBuilder(
                  valueListenable:
                      inject.get<AuthLocalRepository>().userBox.listenable(),
                  builder: (BuildContext context, value, Widget? child) {
                    if (value.values.elementAt(0).phone != null ||
                        value.values.elementAt(0).phone != '') {
                      return Text(
                        value.values.elementAt(0).phone ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    }
                    return const Center();
                  },
                ),
              ],
            ),
          ),
          gapH12,
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Card(
                elevation: 5.0,
                child: ValueListenableBuilder(
                  valueListenable:
                      inject.get<AuthLocalRepository>().userBox.listenable(),
                  builder: (BuildContext context, Box<AuthUser> value,
                      Widget? child) {
                    if (inject
                        .get<AuthLocalRepository>()
                        .guestAccessToken
                        .isNotEmpty) {
                      _isGuestUser = true;
                    } else {
                      _isGuestUser = false;
                    }
                    return Column(
                      children: [
                        if (value.values.elementAt(0).userType ==
                            AuthRole.consumer.name)
                          if (!_isGuestUser)
                            ListTile(
                              onTap: () {
                                context.push(AppRoute.address.toPath);
                              },
                              title: Text(
                                AppLocalizations.of(context)!.address,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.textColor,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20.0,
                                color: AppColor.primaryColor,
                              ),
                            ),
                        const Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        // if (Application.user.userType == '1')
                        if (value.values.elementAt(0).userType ==
                            AuthRole.producer.name)
                          if (!_isGuestUser)
                            ListTile(
                              onTap: () {
                                context.push(AppRoute.offerPage.toPath);
                              },
                              title: const Text(
                                'Apply Offers',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: AppColor.textColor,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20.0,
                                color: AppColor.primaryColor,
                              ),
                            ),
                        const Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        ListTile(
                          onTap: () {
                            context.push(AppRoute.help.toPath);
                          },
                          title: Text(
                            AppLocalizations.of(context)!.help,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20.0,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        ListTile(
                          onTap: () {
                            context.push(AppRoute.faqScreen.toPath);
                          },
                          title: Text(
                            AppLocalizations.of(context)!.faq,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20.0,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        ListTile(
                          onTap: () {
                            context.push(AppRoute.termsOfUse.toPath);
                          },
                          title: Text(
                            AppLocalizations.of(context)!.terms_of_use,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20.0,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        ListTile(
                          onTap: () {
                            context.push(AppRoute.privacyPolicy.toPath);
                          },
                          title: Text(
                            AppLocalizations.of(context)!.privacy_policy,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20.0,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        if (_isGuestUser)
                          const Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                        if (!_isGuestUser)
                          ListTile(
                            onTap: () {
                              context.push(AppRoute.deleteAccount.toPath);
                              // context.push(AppRoute.deleteAccount.toPath);
                            },
                            title: Text(
                              AppLocalizations.of(context)!.delete_account,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 20.0,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        const Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.version,
                              ),
                              Text(
                                Config.appVersion,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          gapH12,
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (_, newState) {
              return newState is AuthLogoutLoadingState ||
                  newState is AuthLogoutLoadingState ||
                  newState is AuthLoggedOutState;
            },
            builder: (context, state) {
              return AppButton(
                isLoading: state is AuthLogoutLoadingState,
                buttonText: AppLocalizations.of(context)!.log_out,
                onPressed: () async {
                  await context.read<AuthCubit>().logout();
                },
              );
            },
          ),
          gapH80,
        ],
      ),
    );
  }
}

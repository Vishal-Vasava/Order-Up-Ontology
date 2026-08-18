import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/screens/components/reason_list.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/clippers.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/confirmation_dialog.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: 'Delete Account',
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(kBorderRadius),
            children: [
              Text(
                'This will remove your account'.hardcoded,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              gapH8,
              Text(
                'You\'re about to start the process of deleting your Order-Up account. Your name and other user information will no longer be viewable on Order-Up for Order-Up iOS or Order-Up Android.'
                    .hardcoded,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              gapH12,
              CustomPaint(
                size: const Size(double.infinity, 4),
                painter: DashedLinePainter(
                  lineColor: AppColor.accentColor,
                ),
              ),
              gapH8,
              Text(
                'Please tell us why you want to delete your account',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const ReasonList(),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (_, newState) {
          return newState is AuthDeleteLoadingState ||
              newState is AuthDeleteSuccessState ||
              newState is AuthDeleteFailedState;
        },
        buildWhen: (_, newState) {
          return newState is AuthDeleteLoadingState ||
              newState is AuthDeleteSuccessState ||
              newState is AuthDeleteFailedState;
        },
        listener: (c, state) {
          if (state is AuthDeleteSuccessState) {
            showSnackBar(
              context: context,
              title: 'Account Deleted'.hardcoded,
              message: 'Your account has been deleted'.hardcoded,
              snackbarType: SnackbarType.success,
            );
          }
          if (state is AuthDeleteFailedState) {
            showSnackBar(
              context: context,
              title: 'Oops! Please try again',
              message: state.message,
              snackbarType: SnackbarType.error,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Note: You might need to Logout and Login again in order to start the process of deleting your account.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: state is AuthDeleteLoadingState
                          ? null
                          : () {
                              if (context
                                  .read<AuthCubit>()
                                  .deleteReason
                                  .isEmpty) {
                                return;
                              }
                              AppDialog.viewDialog(
                                context: context,
                                content: ConfirmationDialog(
                                  swapButtons: false,
                                  height: 250.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  title: 'Are you sure?',
                                  message:
                                      'You want to delete your account?\n\nThis action is irreversible and all relevant user data will be deleted permanently',
                                  onConfirm: () async {
                                    HapticFeedback.lightImpact();
                                    context.pop();
                                    await context
                                        .read<AuthCubit>()
                                        .deleteAccount(
                                          reason: '',
                                        );
                                  },
                                ),
                              );
                            },
                      child: Text(
                        'Delete my account',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColor.whiteColor,
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

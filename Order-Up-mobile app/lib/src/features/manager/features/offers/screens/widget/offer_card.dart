import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_state.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/widgets/app_dialog.dart';
import 'package:orderly_ecom/src/widgets/confirmation_dialog.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferCubit, OfferState>(
      builder: (context, state) {
        if (state is AllOffersLoadedState) {
          return Container(
            height: isDesktop(context) || isTablet(context)
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.height / 8,
            // padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: AppColor.kShadowColor,
                  spreadRadius: 4.5,
                  blurRadius: 4.5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 5,
                  bottom: 20.0,
                  child: Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.rotationZ(-3),
                    child: Icon(
                      kIsWeb
                          ? Icons.percent_rounded
                          : Iconsax.percentage_square,
                      color: AppColor.primaryColor.withOpacity(0.1),
                      size: 80,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    // '${state.allOfferList.data[index].offerPercentage} % Off',
                    state.allOfferList.data[index].title == ''
                        ? 'Test offer'
                        : state.allOfferList.data[index].title!,
                    // 'New Offer on bread',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: BlocBuilder<OfferCubit, OfferState>(
                    buildWhen: (_, newState) {
                      return newState is AllOfferstLoadingState ||
                          newState is AllOffersLoadedState ||
                          newState is AllOffersFailedState;
                    },
                    builder: (c, state) {
                      if (state is AllOffersLoadedState) {
                        return IconButton(
                          onPressed: () {
                            context.pushNamed(AppRoute.editOffer.toName,
                                params: {
                                  'offerId': state.allOfferList.data[index].id
                                });
                          },
                          icon: CircleAvatar(
                            backgroundColor:
                                AppColor.primaryColor.withOpacity(0.7),
                            radius: 18.0,
                            child: const Icon(
                              kIsWeb ? Icons.edit : Iconsax.edit_2,
                              size: 18.0,
                              color: kIsWeb ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: BlocListener<OfferCubit, OfferState>(
                    listenWhen: (_, oldState) {
                      return oldState is DeleteOfferstLoadingState ||
                          oldState is DeleteOffersSuccessState;
                    },
                    listener: (context, state) {
                      if (state is DeleteOffersSuccessState) {
                        showSnackBar(
                          context: context,
                          title: 'Success!!',
                          message: 'Offer Deleted Successfully',
                          snackbarType: SnackbarType.success,
                        );
                      }
                    },
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AppDialog.viewDialog(
                          context: context,
                          content: ConfirmationDialog(
                            swapButtons: false,
                            height: 150.0,
                            width: MediaQuery.of(context).size.width * 0.8,
                            title: 'Are you sure?',
                            message: 'You want to delete this offer?',
                            onConfirm: () async {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                              await context.read<OfferCubit>().deleteOffers(
                                    id: state.allOfferList.data[index].id,
                                  );
                            },
                          ),
                        );
                      },
                      icon: CircleAvatar(
                        backgroundColor: AppColor.accentColor.withOpacity(0.7),
                        radius: 18.0,
                        child: const Icon(
                          kIsWeb ? Icons.delete : Iconsax.trash,
                          size: 18.0,
                          color: kIsWeb ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

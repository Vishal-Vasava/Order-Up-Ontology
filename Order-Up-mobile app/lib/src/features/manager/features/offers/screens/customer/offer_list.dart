import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/cubit/offer_state.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/widget/offer_card.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class OfferList extends StatefulWidget {
  const OfferList({super.key});

  @override
  State<OfferList> createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  @override
  void initState() {
    super.initState();
    context.read<OfferCubit>().getAllOffers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferCubit, OfferState>(
      buildWhen: (_, newState) {
        return newState is OfferCustomerProductInitialState;
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: BlocBuilder<OfferCubit, OfferState>(
            builder: (c, state) {
              return InkWell(
                onTap: () {
                  context.pushNamed(AppRoute.addOffer.toPath);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => BlocProvider.value(
                  //       value: c.read<OfferCubit>(),
                  //       child: const CreateOffers(),
                  //     ),
                  //   ),
                  // );
                },
                child: Container(
                  height: 40.0,
                  width: 145.0,
                  padding: const EdgeInsets.only(left: 2, top: 5, bottom: 5),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColor.whiteColor,
                        radius: 18.0,
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Create Offer',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // appBar: AppBar(
          //   backgroundColor: AppColor.primaryColor,
          //   centerTitle: false,
          //   iconTheme: const IconThemeData(
          //     color: AppColor.whiteColor,
          //   ),
          //   title: const Text(
          //     'Offer List',
          //     style: TextStyle(
          //       color: AppColor.whiteColor,
          //     ),
          //   ),
          // ),
          appBar: OrderlyAppBar(
            title: 'Offer List',
          ),
          body: BlocBuilder<OfferCubit, OfferState>(
            buildWhen: (_, newState) {
              return newState is AllOfferstLoadingState ||
                  newState is AllOffersLoadedState ||
                  newState is AllOffersFailedState;
            },
            builder: (context, state) {
              if (state is AllOffersFailedState) {
                return Center(
                  child: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                  ),
                );
              }
              if (state is AllOfferstLoadingState) {
                if (isDesktop(context) || isTablet(context)) {
                  return AlignedGridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    crossAxisCount: 4,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AppShimmer(
                          height: 200.0,
                        ),
                      );
                    },
                  );
                }
                return AlignedGridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  crossAxisCount: 2,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AppShimmer(
                        height: 200.0,
                      ),
                    );
                  },
                );
              }
              if (state is AllOffersLoadedState) {
                if (isDesktop(context) || isTablet(context)) {
                  return AlignedGridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    crossAxisCount: 4,
                    itemCount: state.allOfferList.data.length,
                    itemBuilder: (context, index) {
                      return OfferCard(
                        index: index,
                      );
                    },
                  );
                }
                return ListView(
                  children: [
                    AlignedGridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      crossAxisCount: 2,
                      itemCount: state.allOfferList.data.length,
                      itemBuilder: (context, index) {
                        return OfferCard(
                          index: index,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/product/screens/cubit/product_cubit.dart';
import 'package:orderly_ecom/src/widgets/image_builder.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({super.key});

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (_, newState) {
        return newState is ProductBannerFailedState ||
            newState is ProductBannerLoadedState ||
            newState is ProductBannerLoadingState;
      },
      builder: (context, state) {
        if (state is ProductBannerLoadingState) {
          return const AppShimmer(
            height: 40,
          );
        }
        if (state is ProductBannerFailedState) {
          return const SizedBox.shrink();
        }
        if (state is ProductBannerLoadedState) {
          if (state.bannerList.isEmpty) {
            return const SizedBox.shrink();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.bannerList.length,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemBuilder: (BuildContext context, int i) {
                return Padding(
                  padding: const EdgeInsets.only(right: kBorderRadius),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      ImageBuilder(
                        borderRadius: 4,
                        imageUrl: state.bannerList[i].imageUrl,
                        height: 0.0,
                        width: null,
                      ),
                      Positioned(
                        // left: 4,
                        top: 1,
                        child: Container(
                          width: 200.0,
                          padding: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(43, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2.0,
                                blurRadius: 20.0,
                                color: Color.fromARGB(35, 230, 230, 230),
                              ),
                            ],
                          ),
                          child: Text(
                            state.bannerList[i].title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

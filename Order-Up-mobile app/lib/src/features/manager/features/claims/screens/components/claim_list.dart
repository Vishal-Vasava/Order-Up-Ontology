import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/components/claim_info.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/cubit/claim_cubit.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/widgets/claim_card.dart';
import 'package:orderly_ecom/src/widgets/default_error_screen.dart';

import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';

class ClaimList extends StatelessWidget {
  const ClaimList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClaimCubit, ClaimState>(
      buildWhen: (_, newState) {
        return newState is ClaimFailedState ||
            newState is ClaimLoadingState ||
            newState is ClaimLoadedState;
      },
      builder: (context, state) {
        if (state is ClaimFailedState) {
          return DefaultErrorScreen(
            message: state.message,
          );
        }
        if (state is ClaimLoadingState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  ...List.generate(
                    4,
                    (index) => const AppShimmer(
                      height: 100.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ClaimLoadedState) {
          if (state.claimDataList.isEmpty) {
            return const Center(
              child: DefaultErrorScreen(
                message: 'No Claims Yet!',
              ),
            );
          }
          if (state.searchClaimDataList.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClaimInfo(
                  paidAmount: state.paidAmount,
                  pendingAmount: state.pendingAmount,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.searchClaimDataList.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (_, int index) {
                      return ClaimCard(
                        modelData: state.searchClaimDataList[index],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ClaimCubit>().getClaimList();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClaimInfo(
                  paidAmount: state.paidAmount,
                  pendingAmount: state.pendingAmount,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.claimDataList.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (_, int index) {
                      return ClaimCard(
                        modelData: state.claimDataList[index],
                      );
                    },
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

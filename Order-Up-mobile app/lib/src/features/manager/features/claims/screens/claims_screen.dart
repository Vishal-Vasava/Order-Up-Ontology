import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/data/claim_repository.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/components/claim_list.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/components/claim_search_bar.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/screens/cubit/claim_cubit.dart';
import 'package:orderly_ecom/src/features/manager/widgets/manager_app_bar.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class ClaimsScreen extends StatelessWidget {
  const ClaimsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ClaimRepository(
        networkAdapter: inject.get<NetworkAdapter>(),
      ),
      child: BlocProvider(
        create: (context) => ClaimCubit(
          claimAdapter: context.read<ClaimRepository>(),
        )..getClaimList(),
        child: BlocBuilder<ClaimCubit, ClaimState>(
          buildWhen: (oldState, _) {
            return oldState is ClaimInitialState;
          },
          builder: (context, state) {
            return Scaffold(
              appBar: ManagerAppBar(
                title: AppLocalizations.of(context)!.claims,
              ),
              body: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClaimSearchBar(),
                  Expanded(child: ClaimList()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

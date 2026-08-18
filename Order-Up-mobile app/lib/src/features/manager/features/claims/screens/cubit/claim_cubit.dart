import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/data/claim_adapter.dart';
import 'package:orderly_ecom/src/features/manager/features/claims/domain/claim.dart';
import 'package:orderly_ecom/src/services/crashlytics/crash_service.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';

part 'claim_state.dart';

class ClaimCubit extends Cubit<ClaimState> implements ClaimAdapter {
  ClaimCubit({required this.claimAdapter}) : super(ClaimInitialState());

  final ClaimAdapter claimAdapter;

  List<ClaimData> claimDataList = [];
  @override
  Future<Claim?> getClaimList() async {
    try {
      emit(ClaimLoadingState());
      final data = await claimAdapter.getClaimList();
      if (data != null) {
        claimDataList = data.claimData;
        emit(ClaimLoadedState(
          paidAmount: data.paidAmount,
          pendingAmount: data.pendingAmount,
          claimDataList: data.claimData,
          searchClaimDataList: const [],
        ));
      } else {
        emit(const ClaimFailedState(message: 'No Claims Yet'));
      }
    } catch (e, stk) {
      emit(ClaimFailedState(message: e.toString()));
      inject
          .get<CrashService>()
          .logError(exception: e, errorMessage: e.toString(), stack: stk);
    }
    return null;
  }

  @override
  void search({required String searchText}) {
    try {
      final ClaimLoadedState currentState = state as ClaimLoadedState;
      emit(ClaimSearchState());
      if (searchText.isNotEmpty) {
        String search = searchText.toLowerCase();
        final List<ClaimData> searchList = [];
        for (final value in claimDataList) {
          if (value.customer.firstName!.toLowerCase().contains(search) ||
              value.orderId.toString().contains(search) ||
              value.customer.lastName!.toLowerCase().contains(search)) {
            searchList.add(value);
          }
        }
        emit(currentState.copyWith(searchClaimDataList: searchList));
      } else {
        emit(currentState.copyWith(searchClaimDataList: []));
      }
    } catch (e) {
      emit(ClaimFailedState(message: e.toString()));
    }
  }
}

part of 'claim_cubit.dart';

abstract class ClaimState extends Equatable {
  const ClaimState();

  @override
  List<Object> get props => [];
}

class ClaimInitialState extends ClaimState {}

/// GET CLAIM DATA STATE
class ClaimLoadingState extends ClaimState {}

class ClaimLoadedState extends ClaimState {
  const ClaimLoadedState({
    required this.paidAmount,
    required this.pendingAmount,
    required this.claimDataList,
    required this.searchClaimDataList,
  });

  final double paidAmount;
  final double pendingAmount;
  final List<ClaimData> claimDataList;
  final List<ClaimData> searchClaimDataList;

  ClaimLoadedState copyWith({List<ClaimData>? searchClaimDataList}) {
    return ClaimLoadedState(
      searchClaimDataList: searchClaimDataList ?? this.searchClaimDataList,
      claimDataList: claimDataList,
      paidAmount: paidAmount,
      pendingAmount: pendingAmount,
    );
  }
}

class ClaimFailedState extends ClaimState {
  const ClaimFailedState({required this.message});

  final String message;
}

class ClaimSearchState extends ClaimState {}

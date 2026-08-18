import 'package:orderly_ecom/src/features/manager/features/claims/domain/claim.dart';

abstract class ClaimAdapter {
  Future<Claim?> getClaimList();

  void search({required String searchText}) =>
      throw UnimplementedError('Search is not implemented');
}

import 'package:dio/dio.dart';
import 'package:orderly_ecom/src/features/negotiation/domain/negotiation_offer.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';

class NegotiationRepository {
  const NegotiationRepository(this.network);

  final NetworkAdapter network;

  Future<NegotiationOffer> createOffer(String message) async {
    try {
      final response = await network.post(
        'negotiation/cart/offer',
        data: {'message': message},
      );
      return NegotiationOffer.fromJson(
        Map<String, dynamic>.from(response.data['data'] as Map),
      );
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        final message = data['message'].toString();
        throw Exception(
          message == 'Invalid Token'
              ? 'Your session expired. Please sign in again.'
              : message,
        );
      }
      throw Exception('The store agent could not respond. Please try again.');
    }
  }

  Future<String> acceptOffer(String offerId) async {
    try {
      final response = await network.post(
        'negotiation/cart/offer/accept',
        data: {'offer_id': offerId},
      );
      return response.data['message']?.toString() ?? 'Offer accepted';
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      throw Exception('The offer could not be accepted.');
    }
  }
}

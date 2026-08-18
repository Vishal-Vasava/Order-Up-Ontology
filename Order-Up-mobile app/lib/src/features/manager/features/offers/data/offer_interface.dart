import 'package:orderly_ecom/src/features/manager/features/offers/domain/all_offers.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/new_customer_product.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/domain/offers_by_id.dart';

abstract class OfferInterface {
  Future<ProductCustomer?> getProductCustomer();

  Future<AllOffers?> getAllOffers();

  Future<bool> deleteOffers({
    required String id,
  });

  Future<OffersById?> getOffersById({
    required String id,
  });

  Future<bool> createOffers({
    required String title,
    required int offerPercentage,
    required String startDate,
    required String endDate,
    required int status,
    required List<String> products,
    required List<String> customers,
  });

  Future<bool> updateOffers({
    required String title,
    required String id,
    required int offerPercentage,
    required String startDate,
    required String endDate,
    required int status,
    required List<String> products,
    required List<String> customers,
  });
}

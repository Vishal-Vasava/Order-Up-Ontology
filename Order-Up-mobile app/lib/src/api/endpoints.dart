import 'package:orderly_ecom/src/config/config.dart';

class Endpoints {
  /// [AGENT]
  static const String agentLogin = 'agent/login';
  static const String agentRefreshToken = 'agent/refresh-token';
  static const String agentOrders = 'agent/orders';
  static const String agentOrderDetail = 'agent/order/details';
  static const String agentOrderStatusUpdate = 'agent/order/status_update';
  static const String agentProfileUpdate = 'agent/profile/update';
  static const String agentDeleteAccount = 'agent/account';

  /// [STORE MANAGER]
  // The bundled Node API exposes the legacy producer login route.
  static const String storeLogin = 'producer_login';
  static const String storeRefreshToken = 'store/refresh-token';
  static const String storeOrders = 'store/orders';
  static const String storeOrderDetailView = 'store/order/details';
  static const String storeClaims = 'store/claims';
  static const String storeCustomers = 'store/customers';

  /// {INVENTORY}
  static const String storeViewInventory = 'store/inventory/view';
  static const String storeCreateInventory = 'store/inventory/create';
  static const String storeUpdateInventory = 'store/inventory/update';
  static const String storeGenerateInventoryImage = 'store/inventory/generate-image';
  static const String storeDeleteInventory = 'store/inventory/delete';
  static const String storeFilters = 'store/filters';

  static const String storeDeleteAccount = 'store/account';
  static const String storeProfileUpdate = 'store/profile/update';
  static const String storeUpdateOrderStatus = 'store/order/status_update';
  static const String storeCancelReason = 'store/cancellation_reasons';
  static const String productCustomerList = 'store/customers_products/';
  static const String getAllOffers = 'store/offers';

  /// [CUSTOMER]
  static const String findStores = 'stores';
  static const String storeProducts = 'store/products';
  static const String storeProductDetail = 'store/product';
  static const String storeProductFilterList = 'store/filter/list';

  static const String cartAdd = 'shopping/cart/add';
  static const String cartUpdate = 'shopping/cart/update';
  static const String cartView = 'shopping/cart';
  static const String cartDelete = 'shopping/cart/delete';
  static const String ordersView = 'shopping/orders';
  static const String orderTrack = 'shopping/orders/track';
  static const String shoppingOrderPlace = 'shopping/order/place';
  static const String shoppingAddressCheck = 'shopping/address/check';
  static const String shoppingOrderInvocie = 'shopping/invoice';
  static const String addReview = 'shopping/order/review/add';

  static const String customerLogin = 'customer/login';
  static const String customerRefreshToken = 'customer/refresh-token';
  static const String customerRegister = 'customer/register';
  static const String customerAddress = 'customer/address';
  static const String customerAddAddress = 'customer/address/add';
  static const String customerUpdateAddress = 'customer/address/update';
  static const String customerDeleteAddress = 'customer/address/delete';
  static const String customerDeleteAccount = 'customer/account';
  static const String customerProfileUpdate = 'customer/profile/update';
  static const String getBanners = 'customer/banners';
  static const String createOffers = 'store/offer/create';
  static const String paymentUrl = 'payment-url';
  static const String paymentConfig = 'shopping/payment-config';

  /// [NOTIFICATIONS] for all `AuthRole`
  static const String customerNotification = 'customer/notifications';
  static const String customerDeleteNotification = 'customer/notification';

  static const String storeNotification = 'store/notifications';
  static const String storeDeleteNotification = 'store/notification';

  static const String agentNotification = 'agent/notifications';
  static const String agentDeleteNotification = 'agent/notification';

  /// [OTHERS] API
  static const String privacyPolicy = 'privacy_policy';
  static const String termsCondition = 'terms_condition';
  static const String faqList = 'faqs';
  static const String removeAccountReasons = 'remove_account_reasons';
  static const String apiHost = 'api-host';

  static String worldPostalLocationApi({
    required String pinCode,
    String countryCode = 'IN',
  }) {
    return 'https://api.worldpostallocations.com/v1/search?apikey=${Config.zipCodeApiKey}&zip_code=$pinCode&country_code=$countryCode';
  }

  /////////////////////////////////////////////////////////////////////////////

  // static const String updateProfile = 'update_producer_profile';
  // static const String removeAccount = 'remove_account';
  // static const String uploadProfileImage = 'update_profile_image';

  // static const String managerOrderDetails = 'producer_orders_details';
  // static const String updateOrderStatus = 'update_order_status';

  // static const String addOrderReview = 'product_review';
  // static const String orderReturn = 'product_return';
  // static const String returnOrderReasons = 'return_order_reasons';

  // static const String managerOrderReturn = 'producer_order_return';

  /// [INVENTORY] API
  static const String skuGalleryList = 'store/sku_gallery';

  // static const String uploadImage = 'uploadImage';

  /// [RETURN POLICY] API
  static const String getProductReason = 'store/returnpolicy/get';
  static const String getPickupEstimates = 'store/estimatedpickup/get';
  static const String returnReplaceOrder = 'customer/order/status_update';
  static const String createEstimates = 'store/estimatedpickup/create';
}

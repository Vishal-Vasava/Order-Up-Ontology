class AppKey {
  static const String googleMapKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String googlePlacesKey =
      String.fromEnvironment('GOOGLE_PLACES_API_KEY');

  static const String mapBoxToken =
      String.fromEnvironment('MAPBOX_ACCESS_TOKEN');

  /// Firebase client configuration.
  static const String fbApiKey =
      String.fromEnvironment('FIREBASE_API_KEY');
  static const String fbAppId =
      String.fromEnvironment('FIREBASE_APP_ID');
  static const String fbMsgSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const String fbProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID');

  static const String stripeKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
  static const String stripeMerchantId =
      String.fromEnvironment('STRIPE_MERCHANT_ID');
}

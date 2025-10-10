class SubscriptionPackageModel {
  final String packageType;
  final double packagePrice;
  final List<String> packageOffersList;
  final bool isActive;
  final String? discountOffer;
  final bool isDiscountOfferAvailable;

  SubscriptionPackageModel({
    required this.packageType,
    required this.isDiscountOfferAvailable,
    required this.packagePrice,
    required this.packageOffersList,
    this.isActive = false,
    this.discountOffer,
  });
}

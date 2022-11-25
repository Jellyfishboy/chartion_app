class DonationPrice {
  final int id;
  final double price;
  final String currency;
  final String formattedPrice;

  DonationPrice({
    required this.id,
    required this.price,
    required this.currency,
    required this.formattedPrice,
  });

  factory DonationPrice.fromJson(Map<String, dynamic> json) {
    return DonationPrice(
      id: json['id'],
      price: json['price'],
      currency: json['currency'],
      formattedPrice: json['formatted_price']
    );
  }
}

class DonationPriceResponse {
  List<DonationPrice> results = [];

  DonationPriceResponse.fromJson(Map<String, dynamic> json) {
    if (json['donation_prices'] != null) {
      json['donation_prices'].forEach((c) {
        results.add(DonationPrice.fromJson(c));
      });
    }
  }
}

import 'package:flutter/material.dart';

class Charity {
  final int id;
  final String name;
  final String description;
  final String registeredNumber;
  final String thumbUrl;
  final String standardUrl;
  final String largeUrl;
  final String uniqId;

  // final String onboardingStep;
  final String currency;

  // final String stripeAccountId;
  bool isFavourite;

  Charity({
    required this.id,
    required this.name,
    required this.description,
    required this.registeredNumber,
    required this.thumbUrl,
    required this.standardUrl,
    required this.largeUrl,
    required this.uniqId,
    // required this.onboardingStep,
    required this.currency,
    // required this.stripeAccountId,
    this.isFavourite = false,
  });

  factory Charity.fromJson(Map<String, dynamic> json) {
    return Charity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      registeredNumber: json['registered_number'],
      thumbUrl: json['logo']['thumb_url'],
      standardUrl: json['logo']['standard_url'],
      largeUrl: json['logo']['large_url'],
      uniqId: json['uniq_id'],
      currency: json['currency'],
    );
  }
}

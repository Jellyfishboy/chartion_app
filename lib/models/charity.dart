import 'package:flutter/material.dart';

class Charity {
  final int id;
  final String name;
  final String description;
  final String registeredNumber;
  final String logoUrl;
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
    required this.logoUrl,
    required this.uniqId,
    // required this.onboardingStep,
    required this.currency,
    // required this.stripeAccountId,
    this.isFavourite = false,
  });
}
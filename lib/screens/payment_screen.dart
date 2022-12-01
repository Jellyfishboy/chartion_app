import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../providers/donation_price.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic paymentData;
  static const routeName = '/donation_payment';

  PaymentScreen({required this.paymentData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Future<void> _priceData;
  bool _isLoading = false;

  // Future<void> createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     Map<String, dynamic> body = {
  //       'amount': 1000,
  //       'currency': 'usd',
  //     };
  //
  //     //Make post request to Stripe
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }
  Future<void> _loadDonationPrice(BuildContext context) async {
    print('LOAD SINGLE DONATION PRICE');
    loadingAnimation(true);
    await Provider.of<DonationPriceProvider>(context, listen: false)
        .findById(widget.paymentData['charityId'] as int,
        widget.paymentData['id'] as int);
    loadingAnimation(false);
  }

  void loadingAnimation(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void initState() {
    _priceData = _loadDonationPrice(context)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Payment'),
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.paymentData['id'].toString()),
          ],
        ),
      ),
    );
  }
}

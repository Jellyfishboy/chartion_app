import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic paymentData;
  static const routeName = '/donation_payment';

  PaymentScreen({required this.paymentData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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

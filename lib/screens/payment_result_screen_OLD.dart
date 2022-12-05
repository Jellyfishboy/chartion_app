// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// import '../providers/donation_price.dart';
//
// class PaymentResultScreen extends StatefulWidget {
//   final dynamic paymentData;
//   static const routeName = '/donation_payment';
//
//   PaymentResultScreen({required this.paymentData});
//
//   @override
//   State<PaymentResultScreen> createState() => _PaymentResultScreenState();
// }
//
// class _PaymentResultScreenState extends State<PaymentResultScreen> {
//   late Future<void> _priceData;
//   // late Future<void> _createPayment;
//   // bool _isLoading = false;
//   // Map<String, dynamic>? paymentIntent;
//
//   // createPaymentIntent() async {
//   //   try {
//   //     //Request body
//   //     Map<String, dynamic> body = {
//   //       'amount': '1000',
//   //       'currency': 'usd',
//   //     };
//   //
//   //     //Make post request to Stripe
//   //     var response = await http.post(
//   //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
//   //       headers: {
//   //         'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
//   //         'Content-Type': 'application/x-www-form-urlencoded'
//   //       },
//   //       body: body,
//   //     );
//   //     return json.decode(response.body);
//   //   } catch (err) {
//   //     throw Exception(err.toString());
//   //   }
//   // }
//
//   // displayPaymentSheet() async {
//   //   try {
//   //     await Stripe.instance.presentPaymentSheet().then((value) {
//   //       // Clear paymentIntent variable after successful payment
//   //       // Redirect to payment result screen
//   //       paymentIntent = null;
//   //       Navigator.of(context).pushNamed(
//   //         PaymentResultScreen.routeName,
//   //         arguments: {
//   //           'sucess': true,
//   //         },
//   //       );
//   //     }).onError((error, stackTrace) {
//   //       throw Exception(error);
//   //     });
//   //   } on StripeException catch (e) {
//   //     // Redirect to payment result screen
//   //     print('Error is:---> $e');
//   //     Navigator.of(context).pushNamed(
//   //       PaymentResultScreen.routeName,
//   //       arguments: {
//   //         'success': false,
//   //       },
//   //     );
//   //   } catch (e) {
//   //     print('$e');
//   //   }
//   // }
//   //
//   // Future<void> createPayment() async {
//   //   try {
//   //     loadingAnimation(true);
//   //     paymentIntent = await createPaymentIntent();
//   //
//   //     await Stripe.instance
//   //         .initPaymentSheet(
//   //             paymentSheetParameters: SetupPaymentSheetParameters(
//   //                 paymentIntentClientSecret: paymentIntent![
//   //                     'client_secret'], //Gotten from payment intent
//   //                 style: ThemeMode.light,
//   //                 merchantDisplayName: 'Chartion'))
//   //         .then((value) {});
//   //
//   //     loadingAnimation(false);
//   //     displayPaymentSheet();
//   //   } catch (err) {
//   //     throw Exception(err);
//   //   }
//   // }
//
//   Future<void> _loadDonationPrice(BuildContext context) async {
//     print('LOAD SINGLE DONATION PRICE');
//     loadingAnimation(true);
//     await Provider.of<DonationPriceProvider>(context, listen: false).findById(
//         widget.paymentData['charityId'] as int,
//         widget.paymentData['id'] as int);
//     loadingAnimation(false);
//   }
//
//   void loadingAnimation(bool isLoading) {
//     setState(() {
//       _isLoading = isLoading;
//     });
//   }
//
//   @override
//   void initState() {
//     // _priceData = _loadDonationPrice(context);
//     // _createPayment = createPayment();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Donate to ${widget.paymentData['charityName']}'),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: FutureBuilder(
//                     future: _createPayment,
//                     builder: (ctx, paymentData) => paymentData
//                                 .connectionState ==
//                             ConnectionState.waiting
//                         ? const Center(
//                             child: CircularProgressIndicator(),
//                           )
//                         : paymentData.hasError
//                             ? Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 30.0, vertical: 0),
//                                   child: Text(paymentData.error.toString()),
//                                 ),
//                               )
//                             : paymentData.hasData
//                                 ? Center(child: Text('Loaded payment'))
//                                 : Center(child: Text('Failed Loading Payment')),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   width: double.infinity,
//                   child: TextButton(
//                     onPressed: () {},
//                     style: TextButton.styleFrom(
//                       primary: Colors.white,
//                       backgroundColor: Theme.of(context).primaryColor,
//                     ),
//                     child: const Text('Complete Payment'),
//                   ),
//                 )
//               ],
//             ),
//     );
//   }
// }

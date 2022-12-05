import 'package:flutter/material.dart';

import './charity_select_donation_screen.dart';

class PaymentResultScreen extends StatelessWidget {
  final dynamic paymentData;
  static const routeName = '/donation_payment';

  PaymentResultScreen({required this.paymentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: paymentData['success']
            ? successfulPayment(context, paymentData)
            : failedPayment(context, paymentData),
      ),
    );
  }
}

Widget successfulPayment(BuildContext context, dynamic paymentData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.done_rounded,
          size: 100.0,
          color: Colors.green,
        ),
        const SizedBox(height: 10),
        const Text(
          'Thank you for using Donkey Donation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Your donation to ${paymentData['charityName']} has been successful!',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            // removes the back button
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('Return Home'),
        )
      ],
    ),
  );
}

Widget failedPayment(BuildContext context, dynamic paymentData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.close_rounded,
          size: 100.0,
          color: Colors.red,
        ),
        const SizedBox(height: 10),
        const Text(
          'Payment failed',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Your donation to ${paymentData['charityName']} has been unsuccessful. Please try again.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // pop the old donation screen route so there is no duplication in the navigation stack
                  Navigator.of(context).pop(CharitySelectDonationScreen.routeName);
                  Navigator.of(context).pushNamed(
                    CharitySelectDonationScreen.routeName,
                    arguments: {'id': paymentData['charityId'], 'name': paymentData['charityName']},
                  );
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Try Again'),
              ),
            ),
            TextButton(
              onPressed: () {
                // removes the back button
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('Return Home'),
            ),
          ],
        )
      ],
    ),
  );
}

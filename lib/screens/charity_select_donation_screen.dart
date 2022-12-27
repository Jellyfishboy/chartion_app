import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../providers/donation_price.dart';

import '../services/stripe_service.dart';

import '../screens/payment_result_screen.dart';

import '../widgets/donation_price_tile.dart';

class CharitySelectDonationScreen extends StatefulWidget {
  final dynamic charityData;
  static const routeName = '/charity_select_donation';

  const CharitySelectDonationScreen({required this.charityData});

  @override
  State<CharitySelectDonationScreen> createState() =>
      _CharitySelectDonationScreenState();
}

class _CharitySelectDonationScreenState
    extends State<CharitySelectDonationScreen> {
  late Future<void> _listDonationPrices;
  Map<String, dynamic>? paymentIntent;
  bool _isLoading = false;
  bool _isPayButtonDisabled = false;
  String _currentSelectedPrice = '0';

  Future<void> _loadDonationPrices(BuildContext context) async {
    print('LOAD DONATION PRICES');
    loadingAnimation(true);
    await Provider.of<DonationPriceProvider>(context, listen: false)
        .listDonationPrices(widget.charityData['id'] as int);
    loadingAnimation(false);
  }

  @override
  initState() {
    _listDonationPrices = _loadDonationPrices(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void loadingAnimation(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void disabledButton(bool isDisabled) {
    setState(() {
      _isPayButtonDisabled = isDisabled;
    });
  }

  void _setSelectedPrice(String value) {
    setState(() {
      _currentSelectedPrice = value;
      print('Selected Price ID: $_currentSelectedPrice');
    });
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        // Clear paymentIntent variable after successful payment
        // Redirect to payment result screen
        paymentIntent = null;
        Navigator.of(context).pushNamed(
          PaymentResultScreen.routeName,
          arguments: {
            'success': true,
            'charityId': widget.charityData['id'],
            'charityName': widget.charityData['name']
          },
        );
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      // Redirect to payment result screen
      print('Error is:---> $e');
      Navigator.of(context).pushNamed(
        PaymentResultScreen.routeName,
        arguments: {
          'success': false,
          'charityId': widget.charityData['id'],
          'charityName': widget.charityData['name']
        },
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<void> createPayment() async {
    try {
      disabledButton(true);
      paymentIntent = await StripeService().createPaymentIntent(
        _currentSelectedPrice,
        widget.charityData['currency'],
        widget.charityData['token'],
      );
      // specify the account id for the charity before creating the payment sheet
      Stripe.stripeAccountId = widget.charityData['stripeAccountId'];

      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  paymentIntent!['payment_intent']['client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Donkey Donate',
              customerEphemeralKeySecret: paymentIntent!['ephemeral_key'],
              customerId: paymentIntent!['payment_intent']['customer']
            ),
          )
          .then((value) {});

      displayPaymentSheet();
      disabledButton(false);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $err')),
      );
      rethrow;
    }
  }

  _donateNowButton() {
    if (_isPayButtonDisabled) {
      return null;
    } else {
      return createPayment();
    }
  }

  // void selectDonationPrice(BuildContext context, int id) {
  //   Navigator.of(context).pushNamed(
  //     PaymentScreen.routeName,
  //     arguments: {
  //       'id': id,
  //       'charityId': widget.charityData['id'],
  //       'charityName': widget.charityData['name'],
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate to ${widget.charityData['name']}'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            width: double.infinity,
            child: const Text(
              'Select Donation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _listDonationPrices,
              builder: (ctx, donationData) => donationData.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : donationData.hasError
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 0),
                            child: Text(donationData.error.toString()),
                          ),
                        )
                      : Consumer<DonationPriceProvider>(
                          builder: (ctx, donationData, child) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: donationData.items.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 0),
                                      child: Text('No donation prices found.'),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                        itemBuilder: (ctx, index) {
                                          return Column(
                                            children: [
                                              DonationPriceTile(
                                                id: donationData
                                                    .items[index].id,
                                                price: donationData
                                                    .items[index].price,
                                                formattedPrice: donationData
                                                    .items[index]
                                                    .formattedPrice,
                                                currentSelectedPrice:
                                                    _currentSelectedPrice,
                                                setSelectedPrice:
                                                    _setSelectedPrice,
                                              ),
                                              Divider(),
                                            ],
                                          );
                                        },
                                        itemCount: donationData.items.length,
                                      ))
                                    ],
                                  ),
                          ),
                        ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _donateNowButton();
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                  _isPayButtonDisabled ? 'Processing...' : 'Complete Payment'),
            ),
          )
        ],
      ),
    );
  }
}

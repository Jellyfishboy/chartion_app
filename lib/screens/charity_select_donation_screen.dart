import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/donation_price.dart';

import '../widgets/donation_price_tile.dart';

class CharitySelectDonationScreen extends StatefulWidget {
  final dynamic charityData;
  static const routeName = '/charity_select_donation';

  const CharitySelectDonationScreen({required this.charityData});

  @override
  State<CharitySelectDonationScreen> createState() =>
      _CharitySelectDonationScreenState();
}

class _CharitySelectDonationScreenState extends State<CharitySelectDonationScreen> {
  late Future<void> _listDonationPrices;
  bool _isLoading = false;

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
          Flexible(
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
                                          return DonationPriceTile(
                                            id: donationData.items[index].id,
                                            formattedPrice: donationData
                                                .items[index].formattedPrice,
                                          );
                                        },
                                        itemCount: 0,
                                      ))
                                    ],
                                  ),
                          ),
                        ),
            ),
          )
        ],
      ),
    );
  }
}

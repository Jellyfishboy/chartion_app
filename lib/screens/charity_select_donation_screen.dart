import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charity.dart';

class CharitySelectDonationScreen extends StatelessWidget {
  static const routeName = '/charity_select_donation';

  @override
  Widget build(BuildContext context) {
    final charityId = ModalRoute.of(context)?.settings?.arguments as int;

    final charityData = Provider.of<CharityProvider>(context, listen: false)
        .findById(charityId);

    return Scaffold(
        appBar: AppBar(
          title: Text('Donate to ${charityData.name}'),
        ),
        body: SingleChildScrollView(
        child: Text('Select Donation')
    ),
    );
  }
}

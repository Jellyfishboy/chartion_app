import 'package:flutter/material.dart';

class DonationPriceTile extends StatelessWidget {
  final int id;
  final String formattedPrice;

  const DonationPriceTile({
    required this.id,
    required this.formattedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // selectDonationPrice(context, id);
      },
      child: ListTile(
        title: Text(formattedPrice),
      ),
    );
  }
}

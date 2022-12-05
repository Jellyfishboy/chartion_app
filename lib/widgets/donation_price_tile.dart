import 'package:flutter/material.dart';

class DonationPriceTile extends StatelessWidget {
  final int id;
  final String price;
  final String formattedPrice;
  final String currentSelectedPrice;
  final Function setSelectedPrice;

  const DonationPriceTile({
    required this.id,
    required this.price,
    required this.formattedPrice,
    required this.currentSelectedPrice,
    required this.setSelectedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // selectDonationPrice(context, id);
      },
      child: RadioListTile(
        value: price,
        groupValue: currentSelectedPrice,
        title: Text(formattedPrice),
        onChanged: (value) {
          setSelectedPrice(value);
        },
        // trailing: ,
      ),
    );
  }
}

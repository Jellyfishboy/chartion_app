import 'package:flutter/material.dart';

class DonationPriceTile extends StatelessWidget {
  final int id;
  final String formattedPrice;
  final int currentSelectPrice;
  final Function setSelectedPrice;

  const DonationPriceTile({
    required this.id,
    required this.formattedPrice,
    required this.currentSelectPrice,
    required this.setSelectedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // selectDonationPrice(context, id);
      },
      child: RadioListTile(
        value: id,
        groupValue: currentSelectPrice,
        title: Text(formattedPrice),
        onChanged: (value) {
          setSelectedPrice(value);
        },
        // trailing: ,
      ),
    );
  }
}

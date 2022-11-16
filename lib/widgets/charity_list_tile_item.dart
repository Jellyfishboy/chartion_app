import 'package:chartion_app/screens/single_charity_screen.dart';
import 'package:flutter/material.dart';

class CharityListTileItem extends StatelessWidget {
  final int id;
  final String name;
  final String thumbUrl;

  CharityListTileItem({
    required this.id,
    required this.name,
    required this.thumbUrl,
  });

  void selectCharity(BuildContext context, int id) {
    Navigator.of(context).pushNamed(
      SingleCharityScreen.routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectCharity(context, id);
      },
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child: Hero(
            tag: id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(thumbUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(name),
      ),
    );
  }
}

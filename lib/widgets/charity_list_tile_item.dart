import 'package:flutter/material.dart';


class CharityListTileItem extends StatelessWidget {
  final int id;
  final String name;

  CharityListTileItem({
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
    );
  }
}

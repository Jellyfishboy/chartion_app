import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charity.dart';
import './charity_list_tile_item.dart';

class CharityListTile extends StatelessWidget {
  CharityListTile();

  @override
  Widget build(BuildContext context) {
    final charityData = Provider.of<CharityProvider>(context);
    final charities = charityData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: charities.length,
      itemBuilder: (ctx, index) {
        return CharityListTileItem(
          id: charities[index].id,
          name: charities[index].name,
          thumbUrl: charities[index].thumbUrl,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/charity.dart';
import '../models/charity.dart';
import './charity_list_tile_item.dart';

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class CharityListTile extends StatefulWidget {
  CharityListTile();

  @override
  State<CharityListTile> createState() => _CharityListTileState();
}

class _CharityListTileState extends State<CharityListTile> {
  final _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final charityData = Provider.of<CharityProvider>(context);
    final charities = charityData.items;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: charities.length,
              itemBuilder: (ctx, index) {
                return CharityListTileItem(
                  id: charities[index].id,
                  name: charities[index].name,
                  thumbUrl: charities[index].thumbUrl,
                );
              },
            ),
          ),
        ]);
  }
}

// TextFormField(
// textInputAction: TextInputAction.search,
// decoration: InputDecoration(
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(25.0),
// borderSide: BorderSide(
// color: Colors.grey,
// ),
// ),
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20.0),
// borderSide: BorderSide(
// color: Colors.blue,
// ),
// ),
// suffixIcon: InkWell(
// child: Icon(Icons.search),
// ),
// contentPadding: EdgeInsets.all(15.0),
// hintText: 'Search ',
// ),
// // change to onFieldSubmitted
// onChanged: (string) {
// _debouncer.run(() {
// setState((){
// _searchCharities(string);
// });
// });
// },
// ),
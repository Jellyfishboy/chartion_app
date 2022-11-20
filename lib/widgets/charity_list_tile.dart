import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/charity.dart';
import '../models/charity.dart';
import './charity_list_tile_item.dart';

class CharityListTile extends StatefulWidget {

  CharityListTile();

  @override
  State<CharityListTile> createState() => _CharityListTileState();
}

class _CharityListTileState extends State<CharityListTile> {
  List<Charity> charityData = [];

  Future<void> _searchCharities(String query) async {
      final url = Uri.parse("https://capi.tomdallimore.com/v1/charities/search/results?query=$query");
      try {
        List<Charity> loadedCharities;
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonResponseList = jsonDecode(response.body)['charities'] as List;
          loadedCharities = jsonResponseList
              .map((e) => Charity.fromJson(e as Map<String, dynamic>))
              .toList();
          charityData =  loadedCharities;
        } else {
          throw "No charities found with this search query.";
        }
      } catch (error) {
        throw error;
      }
  }

  @override
  Widget build(BuildContext context) {
    final charityData = Provider.of<CharityProvider>(context);
    final charities = charityData.items;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              suffixIcon: InkWell(
                child: Icon(Icons.search),
              ),
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Search ',
            ),
            // change to onFieldSubmitted
            onFieldSubmitted: (string) {},
            onChanged: (string) {
              print(string);
              setState((){
                _searchCharities(string);
              }
              );
            },
          ),
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

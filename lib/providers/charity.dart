import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../models/charity.dart';

class CharityProvider with ChangeNotifier {
  List<Charity> _items = [];

  CharityProvider();

  List<Charity> get items {
    return [..._items];
  }

  Charity findById(int charityId) {
    return items.firstWhere((charity) => charity.id == charityId);
  }

  Future<void> listCharities() async {
    final url = Uri.parse('https://capi.tomdallimore.com/v1/charities');
    try {
      List<Charity> loadedCharities;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponseList = jsonDecode(response.body)['charities'] as List;
        loadedCharities = jsonResponseList
            .map((e) => Charity.fromJson(e as Map<String, dynamic>))
            .toList();
        _items = loadedCharities;
        notifyListeners();
      } else {
        throw "Can't retrieve Charities.";
      }
    } catch (error) {
      throw error;
    }
  }
}

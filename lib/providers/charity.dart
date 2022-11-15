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
      final response = await http.get(url);
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<Charity> loadedCharities = [];
      if (jsonResponse == null) {
        return;
      }
      jsonResponse.forEach((charityId, charityData) {
        loadedCharities.add(
          Charity(
            id: charityData['id'],
            name: charityData['name'],
            description: charityData['description'],
            registeredNumber: charityData['registered_number'],
            logoUrl: charityData['logo']['thumb_url'],
            uniqId: charityData['uniq_id'],
            currency: charityData['currency'],
          ),
        );
      });
      _items = loadedCharities;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

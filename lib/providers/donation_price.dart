import 'package:flutter/material.dart';

import '../helpers/api_base_helper.dart';
import '../models/donation_price.dart';
import '../enums/data_state.dart';

class DonationPriceProvider with ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<DonationPrice> _items = [];
  DataState _dataState = DataState.Uninitialized;

  DonationPriceProvider();

  List<DonationPrice> get items {
    return [..._items];
  }

  DataState get dataState {
    return _dataState;
  }

  Future<void> listDonationPrices(int charityId) async {
    try {
      final response =
          await _helper.get('/charities/$charityId/donations/prices');
      print(response);
      DonationPriceResponse donationPriceResponse =
          DonationPriceResponse.fromJson(response);
      _items = donationPriceResponse.results;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

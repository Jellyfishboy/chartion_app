import 'package:flutter/material.dart';

import '../helpers/api_base_helper.dart';
import '../models/donation_price.dart';
import '../enums/data_state.dart';

class DonationPriceProvider with ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<DonationPrice> _items = [];
  late DonationPrice _singleItem;
  DataState _dataState = DataState.Uninitialized;

  DonationPriceProvider();

  List<DonationPrice> get items {
    return [..._items];
  }

  DonationPrice get singleItem {
    return _singleItem;
  }

  DataState get dataState {
    return _dataState;
  }

  Future<void> findById(int charityId, int donationPriceId) async {
    try {
      _dataState = (_dataState == DataState.Uninitialized)
          ? DataState.InitialFetching
          : DataState.MoreFetching;
      final response = await _helper.get(
          '/charities/$charityId/donations/prices/$donationPriceId');
      print(response);
      DonationPrice priceResponse = DonationPrice.fromJson(response);
      _singleItem = priceResponse;
      notifyListeners();
    } catch(error) {
      throw error;
    }
    // return items.firstWhere((charity) => charity.id == charityId);
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

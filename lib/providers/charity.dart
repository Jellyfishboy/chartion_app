import 'package:flutter/material.dart';

import '../helpers/api_base_helper.dart';
import '../models/charity.dart';

class CharityProvider with ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<Charity> _items = [];
  int _totalResults = 0;
  int _perPage = 25;
  int _totalPages = 0;
  int _currentPage = 1;


  CharityProvider();

  List<Charity> get items {
    return [..._items];
  }

  int get totalResults {
   return _totalResults;
  }

  int get perPage {
    return _perPage;
  }

  int get totalPages {
    return _totalPages;
  }

  int get currentPage {
    return _currentPage;
  }

  Charity findById(int charityId) {
    return items.firstWhere((charity) => charity.id == charityId);
  }

  Future<void> searchCharities(String query) async {
    try {

      final response = await _helper.get('/charities/search/results?query=$query');
      print(response);
      CharityResponse charityResponse = CharityResponse.fromJson(response);
      _items = charityResponse.results;
      _totalResults = charityResponse.totalResults;
      _perPage = charityResponse.perPage;
      _totalPages = charityResponse.totalPages;
      _currentPage = charityResponse.currentPage;
    } catch (error) {
      throw error;
    }
  }

  Future<void> listCharities() async {
    try {
      final response = await _helper.get('/charities');
      CharityResponse charityResponse = CharityResponse.fromJson(response);
      _items = charityResponse.results;
      _totalResults = charityResponse.totalResults;
      _perPage = charityResponse.perPage;
      _totalPages = charityResponse.totalPages;
      _currentPage = charityResponse.currentPage;
    } catch (error) {
      throw error;
    }
  }
}

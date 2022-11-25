import 'package:flutter/material.dart';

import '../helpers/api_base_helper.dart';
import '../models/charity.dart';
import '../enums/data_state.dart';

class CharityProvider with ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<Charity> _items = [];
  int _totalResults = 0;
  int _perPage = 25;
  int _totalPages = 5;
  int _currentPage = 1;
  DataState _dataState = DataState.Uninitialized;


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

  DataState get dataState {
    return _dataState;
  }

  bool get _didLastLoad {
    return _currentPage >= _totalPages;
  }

  Charity findById(int charityId) {
    return items.firstWhere((charity) => charity.id == charityId);
  }

  Future<void> searchCharities({String query="", isRefresh=false, loadMore=false}) async {
    try {
      if (isRefresh) {
        _items.clear();
        _currentPage = 1;
        _dataState = DataState.Refreshing;
      } else {
        _dataState = (_dataState == DataState.Uninitialized)
            ? DataState.InitialFetching
            : DataState.MoreFetching;
      }
      print("Total Pages: ${_totalPages}");
      print("Did last load ${_didLastLoad}");
      if (_didLastLoad) {
        _dataState = DataState.NoMoreData;
      } else {
        if (!loadMore) {
          _items.clear();
          _currentPage = 1;
        } else {
          _currentPage += 1;
        }
        final response = await _helper.get(
            '/charities/search/results?query=$query&per_page=10&page=1');
        print(response);
        CharityResponse charityResponse = CharityResponse.fromJson(response);
        if (isRefresh || !loadMore) {
          _items = charityResponse.results;
        }
        _totalResults = charityResponse.totalResults;
        _perPage = charityResponse.perPage;
        _totalPages = charityResponse.totalPages;
        _currentPage = charityResponse.currentPage;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> listCharities({isRefresh=false, loadMore=false, clearSearch=false}) async {
    print('LIST CHARITIES');
    print ('Load last ${_didLastLoad}');
    print('Current Page ${_currentPage}');
    try {
      if (clearSearch) {
        _totalPages = 5;
      }
      if (isRefresh) {
        _items.clear();
        _currentPage = 1;
        _dataState = DataState.Refreshing;
      } else {
        _dataState = (_dataState == DataState.Uninitialized)
            ? DataState.InitialFetching
            : DataState.MoreFetching;
      }
      print("Total Pages: ${_totalPages}");
      print("Did last load ${_didLastLoad}");
      if (_didLastLoad) {
        _dataState = DataState.NoMoreData;
       } else {
        if (!loadMore) {
          _items.clear();
          _currentPage = 1;
        } else {
          _currentPage += 1;
        }
        final response = await _helper.get(
            '/charities?per_page=11&page=$_currentPage');
        CharityResponse charityResponse = CharityResponse.fromJson(response);
        _items += charityResponse.results;
        _totalResults = charityResponse.totalResults;
        _perPage = charityResponse.perPage;
        _totalPages = charityResponse.totalPages;
        _currentPage = charityResponse.currentPage;
      }
      notifyListeners();
    } catch (error) {
      _dataState = DataState.Error;
      throw error;
      notifyListeners();
    }
  }


}

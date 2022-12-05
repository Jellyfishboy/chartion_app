import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'global_data.dart';

import '../exceptions/app_exception.dart';

class ApiBaseHelper {

  Future<dynamic> get(String url) async {
    Map<String, dynamic> responseJson;
    try {
      final formattedUrl = Uri.parse(GlobalData.baseApiUrl + url);
      final response = await http.get(formattedUrl);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

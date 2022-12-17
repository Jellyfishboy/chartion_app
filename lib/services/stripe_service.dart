import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/global_data.dart';
import '../helpers/hmac_sign.dart';

class StripeService {

  createPaymentIntent(String amount, String currency, String charityToken) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };
      // Make post request to Chartion api
      final String hmacInput = 'amount=${body['amount']}&currency=${body['currency']}';
      var response = await http.post(
        Uri.parse(GlobalData.baseApiUrl + 'charities/$charityToken/stripe/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${HmacSign(hmacInput).signedHmac}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = ((double.parse(amount)) * 100).toInt();
    return calculatedAmount.toString();
  }
}
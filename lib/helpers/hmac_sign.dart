import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HmacSign {

  final dynamic inputData;
  static String apiSecret = dotenv.env['CHARTION_API_SECRET'] as String;

  HmacSign(this.inputData);

  String get signedHmac {
    try {
      // List<int> messageBytes = utf8.encode("amount=500&currency=gbp");
      // List<int> key = base64.decode(base64.normalize("MCbDv7unok7thvAoxAvvyf3FxWfWxGcDkNAfA8suxxU_VzaTVMGxYJa2_ETHiszBZzjGLsR9NxwRz1sXcyryyC9m8_sNwwfPKEc"));
      // Hmac hMacSha256 = new Hmac(sha256, key);
      // Digest digest = hMacSha256.convert(messageBytes);
      //
      // String base64Mac = base64Encode(digest.bytes);
      // print(base64Mac);
      // return base64Mac;

      var key = utf8.encode(apiSecret);
      var bytes = utf8.encode(inputData);
      print(key);
      var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
      var digest = hmacSha256.convert(bytes);
      String base64Mac = base64Encode(digest.bytes);

      print("HMAC digest as bytes: ${digest.bytes}");
      print("HMAC digest as hex string: $digest");
      print("HMAC digest as base64: $base64Mac");
      return base64Mac;
    } catch(error) {
      throw error;
    }
  }
}
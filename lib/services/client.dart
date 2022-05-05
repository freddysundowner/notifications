import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notifications/configs/configs.dart';

class DbBase {
  var postRequestType = "POST";

  databaseRequest(String type, {Map<String, dynamic>? body}) async {
    try {
      var request = http.Request(type, Uri.parse(api_url));

      if (body != null) {
        request.body = json.encode(body);
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 404) {
        print("Error 404");
      }

      return response.stream.bytesToString();
    } catch (e, s) {
      print("Error on api $e $s");
    }
  }
}

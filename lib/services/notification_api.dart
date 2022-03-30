
import 'dart:convert';

import 'package:fluttergistshop/utils/functions.dart';

import 'client.dart';
import 'end_points.dart';

class NotificationApi {

  sendNotification(List userIds, String title, String message, String screen, String id) async {
    try {

      var body = {
        "users": userIds,
        "title": title,
        "message": message,
        "screen": screen,
        "id": id
      };

      var response = await DbBase().databaseRequest(
          notifications, DbBase().postRequestType,
          body: body);

      printOut("response ${jsonDecode(response)["Success"]}");
    } catch (e, s) {
      printOut("Error sending notifications $e $s");
    }
  }
}
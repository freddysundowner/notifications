import 'dart:convert';

import 'client.dart';
import 'end_points.dart';

class UserAPI {
  getAllUsers() async {
    var users =
    await DbBase().databaseRequest(allUsers, DbBase().getRequestType);

    return jsonDecode(users);
  }

}
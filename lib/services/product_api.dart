import 'dart:convert';

import 'client.dart';
import 'end_points.dart';

class ProductPI {
  getAllRooms() async {
    var rooms =
    await DbBase().databaseRequest(allRooms, DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  getUserProducts(String userId) async {
    var products = await DbBase()
        .databaseRequest(userProducts + userId, DbBase().getRequestType);
    return jsonDecode(products);
  }
}
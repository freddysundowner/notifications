import 'dart:convert';

import 'client.dart';
import 'end_points.dart';

class RoomAPI {
  getAllRooms() async {
    var rooms =
        await DbBase().databaseRequest(allRooms, DbBase().getRequestType);


    return jsonDecode(rooms);
  }

  getRoomById(String uid) async {
    var room =
        await DbBase().databaseRequest(roomById + uid, DbBase().getRequestType);
    return jsonDecode(room);
  }
}

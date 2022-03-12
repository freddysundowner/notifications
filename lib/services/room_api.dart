import 'dart:convert';

import 'client.dart';
import 'end_points.dart';

class RoomAPI {
  getAllRooms() async {
    var rooms =
        await DbBase().databaseRequest(allRooms, DbBase().getRequestType);


    return jsonDecode(rooms);
  }

  getRoomById(String roomId) async {
    var room =
        await DbBase().databaseRequest(roomById + roomId, DbBase().getRequestType);
    return jsonDecode(room);
  }
}

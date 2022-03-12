import 'dart:convert';

import 'package:fluttergistshop/utils/Functions.dart';

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

/*  saveRoom(Map<String, dynamic> roomData, String roomId, {List<String> toNotify}) async {

    var body = {
      "room": roomData,
      "owner": Get.find<UserController>().user.toMap(),
      "notify": toNotify
    };

    try {
      await DbBase().databaseRequest(SAVE_ROOM + roomId, DbBase().postRequestType, body: body);
    } catch (e) {
      Functions.debug(e);
    }
  }*/

  updateRoomById(Map<String, dynamic> body, String id) async {
    try {
      await DbBase()
          .databaseRequest(updateRoom + id, DbBase().patchRequestType, body: body);
    } catch (e) {
      printOut("Error updating room $e");
    }
  }

  removeUserFromAudienceInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase()
          .databaseRequest(removeUserFromAudience + id, DbBase().patchRequestType, body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeUserFromSpeakerInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase()
          .databaseRequest(removeSpeaker + id, DbBase().patchRequestType, body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeUserFromRaisedHandsInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase()
          .databaseRequest(removeUserFromRaisedHands + id, DbBase().patchRequestType, body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }
}

import 'dart:convert';

import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

import 'client.dart';
import 'end_points.dart';

class RoomAPI {
  getAllRooms() async {
    var rooms =
        await DbBase().databaseRequest(allRooms, DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  getRoomById(String roomId) async {
    var room = await DbBase()
        .databaseRequest(roomById + roomId, DbBase().getRequestType);
    printOut("Getting room ${jsonDecode(room)}");
    return jsonDecode(room);
  }

  createARoom(Map<String, dynamic> roomData) async {
    try {
      printOut("create $roomData");
      var room = await DbBase().databaseRequest(
          createRoom + Get.find<AuthController>().usermodel.value!.id!,
          DbBase().postRequestType,
          body: roomData);

      printOut("created room $room");
      return jsonDecode(room);
    } catch (e, s) {
      printOut("Error creating room $e $s");
    }
  }

  generateAgoraToken(String channel, String uid) async {
    try {
      var genToken = await DbBase().databaseRequest(
          tokenPath + "?channel=$channel&uid=$uid'", DbBase().getRequestType);
      if (genToken != null) {
        return jsonDecode(genToken)["token"];
      } else {
        printOut('Failed to load token');
        throw Exception('Failed to load token');
      }
    } catch (e, s) {
      printOut("Error generating agora token room $e $s");
    }
  }

  updateRoomById(Map<String, dynamic> body, String id) async {
    final RoomController _homeController = Get.find<RoomController>();
    try {
      if (body["title"] == null) {
        body.addAll({"title": _homeController.currentRoom.value.title});
      }

      printOut("Room to be updated title ${body["title"]}");
      var updated = await DbBase().databaseRequest(
          updateRoom + id, DbBase().patchRequestType,
          body: body);

      printOut("updatedRoom $updated");
    } catch (e) {
      printOut("Error updating room $e");
    }
  }

  removeUserFromAudienceInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeUserFromAudience + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeUserFromSpeakerInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeSpeaker + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeUserFromHostInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(removeHost + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromHost room $e");
    }
  }

  removeUserFromRaisedHandsInRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeUserFromRaisedHands + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeUserFromAudience  room $e");
    }
  }

  removeAUserFromRoom(Map<String, dynamic> body, String id) async {
    try {
      await DbBase().databaseRequest(
          removeUserFromRoom + id, DbBase().patchRequestType,
          body: body);
    } catch (e) {
      printOut("Error removeAUserFromRoom  room $e");
    }
  }

  deleteARoom(String id) async {
    try {
      await DbBase()
          .databaseRequest(deleteRoom + id, DbBase().deleteRequestType);
    } catch (e) {
      printOut("Error deleteARoom  room $e");
    }
  }
}

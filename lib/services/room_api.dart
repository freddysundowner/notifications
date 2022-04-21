import 'dart:convert';

import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

import 'client.dart';
import 'end_points.dart';

class RoomAPI {
  getAllRooms() async {
    var rooms = await DbBase().databaseRequest(
        allRooms + Get.find<AuthController>().usermodel.value!.id!,
        DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  getAllRoomsPaginated(int pageNumber) async {
    var rooms = await DbBase().databaseRequest(
        allRoomsPaginated +
            Get.find<AuthController>().usermodel.value!.id! +
            "/$pageNumber",
        DbBase().getRequestType);

    var decodedRooms = jsonDecode(rooms);
    var finalRooms = [];

    for (var a in decodedRooms.elementAt(0)["data"]) {
      a["ownerId"] = a["ownerId"].isEmpty ? null : a["ownerId"].elementAt(0);
      a["ownerId"]["shopId"] = a["ownerId"]["shopId"].isEmpty ? null : a["ownerId"]["shopId"].elementAt(0);
      a["shopId"] = a["shopId"].isEmpty ? null : a["shopId"].elementAt(0);
      a["productIds"].elementAt(0)["ownerId"] = a["productIds"].elementAt(0)["ownerId"].isEmpty ? null : a["productIds"].elementAt(0)["ownerId"].elementAt(0);
      a["productIds"].elementAt(0)["ownerId"]["shopId"] = a["productIds"].elementAt(0)["ownerId"]["shopId"].isEmpty ? null : a["productIds"].elementAt(0)["ownerId"]["shopId"].elementAt(0);

      printOut("Outed room $a");
      finalRooms.add(a);
    }
    return finalRooms;
  }

  getAllMyEvents() async {
    var rooms = await DbBase().databaseRequest(
        myEvents + "/" + Get.find<AuthController>().usermodel.value!.id!,
        DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  getAllEvents() async {
    var rooms =
        await DbBase().databaseRequest(allEvents, DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  getRoomById(String roomId) async {
    var room = await DbBase()
        .databaseRequest(roomById + roomId, DbBase().getRequestType);
    printOut("Getting room ${jsonDecode(room)}");
    return jsonDecode(room);
  }

  getEventById(String roomId) async {
    var room = await DbBase()
        .databaseRequest(eventById + roomId, DbBase().getRequestType);
    printOut("Getting room ${jsonDecode(room)} $roomId");
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

  createEvent(Map<String, dynamic> roomData) async {
    try {
      printOut("create createEventE $roomData");
      var room = await DbBase().databaseRequest(
          createEventE + Get.find<AuthController>().usermodel.value!.id!,
          DbBase().postRequestType,
          body: roomData);

      printOut("created createEventE $room");
      return jsonDecode(room);
    } catch (e, s) {
      printOut("Error creating room $e $s");
    }
  }

  generateAgoraToken(String channel, String uid) async {
    try {
      var data = {"channel": channel, "uid": uid};

      var token = await DbBase()
          .databaseRequest(tokenPath, DbBase().postRequestType, body: data);

      if (token != null) {
        return jsonDecode(token)["token"];
      } else {
        printOut('Failed to load token');
        throw Exception('Failed to load token');
      }
    } catch (e, s) {
      printOut("Error generating agora token room $e $s");
    }
  }

  updateRoomByIdNew(Map<String, dynamic> body, String id) async {
    print("updateRoomByIdNew $body");
    print("updateRoomByIdNew $id");
    try {
      var updated = await DbBase().databaseRequest(
          updateRoomNew + id, DbBase().patchRequestType,
          body: body);
      printOut("updateRoomByIdNew $updated");
      return jsonDecode(updated);
    } catch (e) {
      printOut("Error updateRoomByIdNew room $e");
    }
  }

  updateRoomById(Map<String, dynamic> body, String id) async {
    final RoomController _homeController = Get.find<RoomController>();
    try {
      if (body["title"] == null) {
        body.addAll({"title": _homeController.currentRoom.value.title});
      }
      if (body["activeTime"] == null) {
        body.addAll({
          "activeTime": _homeController.currentRoom.value.activeTime,
        });
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

  addUserrToRoom(Map<String, dynamic> body, String id) async {
    try {
      var updated = await DbBase().databaseRequest(
          addUserToRoom + id, DbBase().patchRequestType,
          body: body);

      printOut("addUserrToRoom $updated");
    } catch (e) {
      printOut("Error addUserrToRoom room $e");
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

  recordRoom(String id, String token) async {
    try {
      var response = await DbBase()
          .databaseRequest(record + id, DbBase().postRequestType, body: {
        "token": token,
        "roomuid": Get.find<AuthController>().usermodel.value!.roomuid,
      });
      print("recordRoom $response");
      return jsonDecode(response);
    } catch (e) {
      printOut("Error deleteARoom  room $e");
    }
  }

  sendRoomNotication(Map<String, dynamic> body) async {
    print("sendRoomNotication ${body["room"]}");
    try {
      var updated = await DbBase().databaseRequest(
          roomNotication, DbBase().postRequestType,
          body: body);
      return jsonDecode(updated);
    } catch (e) {
      printOut("Error sendRoomNotication room $e");
    }
  }
}

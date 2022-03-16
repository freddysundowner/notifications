import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/room/room_page.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'auth_controller.dart';

class RoomController extends GetxController {
  RtcEngineContext context = RtcEngineContext(agoraAppID);
  late RtcEngine engine;

  var isLoading = false.obs;
  var allUsersLoading = false.obs;
  var allUsers = [].obs;
  var isCurrentRoomLoading = false.obs;
  var roomsList = [].obs;
  var currentRoom = RoomModel().obs;
  var isCreatingRoom = false.obs;
  var newRoom = RoomModel().obs;
  var toInviteUsers = [].obs;
  var audioMuted = true.obs;

  var newRoomTitle = " ".obs;
  var newRoomType = "public".obs;
  var agoraToken = "".obs;
  var roomPickedProductId = "".obs;
  var roomPickedProductPrice = "".obs;
  var roomHosts = <UserModel>[].obs;
  var roomShopId = "".obs;
  var roomProductImages = [].obs;

  var userProducts = [].obs;
  var userProductsLoading = false.obs;
  var userJoinedRoom = false.obs;

  @override
  void onInit() {
    getRooms();
    super.onInit();
  }

  getRooms() async {
    await fetchRooms();
    printOut(roomsList.length);
  }

  Future<void> createRoom() async {
    try {
      roomHosts.add(Get.find<AuthController>().usermodel.value!);
      isCreatingRoom.value = true;

      Get.defaultDialog(
          title: "We are creating your room",
          content: CircularProgressIndicator(),
          barrierDismissible: false);

      var hosts = [];
      for (var element in roomHosts) {
        hosts.add(element.id);
      }

      var roomData = {
        "title": newRoomTitle.value,
        "roomType": newRoomType.value,
        "productIds": [roomPickedProductId.value],
        "hostIds": hosts,
        "userIds": [],
        "raisedHands": [],
        "speakerIds": [],
        "invitedIds": [],
        "shopId": Get.find<AuthController>().usermodel.value!.shopId ?? " ",
        "status": true,
        "productPrice": roomPickedProductPrice.value,
        "productImages": roomProductImages
      };

      var rooms = await RoomAPI().createARoom(roomData);

      printOut("room created $rooms");

      if (rooms != null) {
        var roomId = rooms["_id"];
        var token = await RoomAPI().generateAgoraToken(roomId, "0");
        printOut("room token $token");

        if (token != null) {
          await RoomAPI()
              .updateRoomById({"title": " ", "token": token}, roomId);

          await fetchRoom(roomId);

          initAgora(token, roomId);

          Get.back();
          Get.to(RoomPage(roomId: roomId));
        } else {
          Get.back();
          Get.snackbar(
              "", "There was an error creating your room. Try again later");
          await RoomAPI().deleteARoom(roomId);
        }
      } else {
        Get.back();
        Get.snackbar("", "Error creating your room");
      }

      isCreatingRoom.value = false;

      update();
    } catch (e, s) {
      Get.back();
      printOut("Error creating room in controller $e $s");
      isCreatingRoom.value = false;
    }
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;

      var rooms = await RoomAPI().getAllRooms();

      if (rooms != null) {
        roomsList.value = rooms;
      } else {
        roomsList.value = [];
      }
      roomsList.refresh();
      isLoading.value = false;

      update();
    } catch (e) {
      printOut(e);
      isLoading.value = false;
    }
  }

  Future<void> fetchUserCurrentRoom() async {
    try {
      isLoading.value = true;

      var room = await RoomAPI().getRoomById("61fb9094d59efb5046a99946");

      if (room != null) {
        currentRoom.value = RoomModel.fromJson(room);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoom(String roomId) async {
    printOut("RoomId $roomId");

    try {
      isCurrentRoomLoading.value = true;

      var roomResponse = await RoomAPI().getRoomById(roomId);

      if (roomResponse != null) {
        RoomModel room = RoomModel.fromJson(roomResponse);
        if (room.token != null) {
          currentRoom.value = room;
        }
      } else {
        Get.snackbar('', "Error getting your room, Try again later");
      }
      isCurrentRoomLoading.value = false;
      update();
      printOut("Room $roomResponse");
    } catch (e) {
      printOut("Error getting individual room " + e.toString());
      isCurrentRoomLoading.value = false;
    }
  }

  Future<void> addUserToRoom(OwnerId user) async {
    printOut(
        "current user being added to room token ${currentRoom.value.token}");

    if (currentRoom.value.token != null) {
      initAgora(currentRoom.value.token, currentRoom.value.id!);

      printOut("current user being added to room ${user.id}");

      if ((currentRoom.value.hostIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) &&
          (currentRoom.value.speakerIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) &&
          (currentRoom.value.userIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1)) {
        currentRoom.value.userIds!.add(user);

        currentRoom.refresh();

        //Add user to room
        await RoomAPI().updateRoomById({
          "title": currentRoom.value.title ?? " ",
          "userIds": [user.id],
          "token": currentRoom.value.token
        }, currentRoom.value.id!);
      }
    }
  }

  Future<void> addUserToSpeaker(OwnerId user) async {
    currentRoom.value.speakerIds!.add(user);
    currentRoom.value.userIds!.remove(user);

    currentRoom.refresh();

    //Add user to speakers
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "speakerIds": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);

    //Remove user from audience
    await RoomAPI().removeUserFromAudienceInRoom({
      "users": [user.id]
    }, currentRoom.value.id!);

    //Remove user from RaisedHand
    await RoomAPI().removeUserFromRaisedHandsInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> addUserToRaisedHands(OwnerId user) async {
    currentRoom.value.raisedHands!.add(user);

    Get.snackbar('', "You have raised your hand");

    currentRoom.refresh();

    //Add user to raisedHands
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "raisedHands": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> removeUserFromSpeaker(OwnerId user) async {
    currentRoom.value.speakerIds!.remove(user);
    currentRoom.value.userIds!.add(user);

    currentRoom.refresh();

    //Add user to speakers
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "userIds": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
    //Remove user from audience
    await RoomAPI().removeUserFromSpeakerInRoom({
      "speakerIds": [user.id]
    }, currentRoom.value.id!);
  }

  Future<void> removeUserFromRaisedHands(OwnerId user) async {
    currentRoom.value.speakerIds!.add(user);
    currentRoom.value.raisedHands!.remove(user);

    currentRoom.refresh();

    //Add user to speakers
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "speakerIds": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);

    //Remove user from RaisedHand
    await RoomAPI().removeUserFromRaisedHandsInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);

    //Remove user from RaisedHand
    await RoomAPI().removeUserFromAudienceInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> leaveRoom(OwnerId user) async {
    leaveAgora();

    currentRoom.value.speakerIds!.remove(user);
    currentRoom.value.userIds!.remove(user);
    currentRoom.value.raisedHands!.remove(user);

    currentRoom.refresh();
    if (currentRoom.value.hostIds!.length == 1 &&
        currentRoom.value.hostIds!.contains(user)) {
      await RoomAPI().deleteARoom(currentRoom.value.id!);
    } else {
      await RoomAPI().removeAUserFromRoom({
        "users": [user.id]
      }, currentRoom.value.id!);
    }

    currentRoom.value = RoomModel();
  }

  @override
  void dispose() {
    leaveAgora();
    super.dispose();
  }

  Future<void> leaveAgora() async {
    await engine.leaveChannel();
    await engine.disableAudio();
    await engine.destroy();
  }

  Future<void> fetchAllUsers() async {
    if (allUsers.isEmpty) {
      try {
        allUsersLoading.value = true;

        var users = await UserAPI().getAllUsers();

        if (users != null) {
          allUsers.value = users;
        } else {
          allUsers.value = [];
        }
        allUsers.refresh();
        allUsersLoading.value = false;

        update();
      } catch (e) {
        printOut(e);
        allUsersLoading.value = false;
      }
    }
  }

  Future<void> fetchUserProducts() async {
    try {
      userProductsLoading.value = true;

      var products = await ProductPI()
          .getUserProducts(Get.find<AuthController>().usermodel.value!.id!);

      printOut("products $products");

      if (products != null) {
        userProducts.value = products;
      } else {
        userProducts.value = [];
      }
      userProducts.refresh();
      userProductsLoading.value = false;

      update();
    } catch (e) {
      printOut(e);
      userProductsLoading.value = false;
    }
  }

  void initAgora(String token, String roomId) async {
    try {
      printOut("Joining agora room");

      // Get microphone permission
      await [Permission.microphone].request();

      // Create RTC client instance
      engine = await RtcEngine.createWithContext(context);

      // Define event handling logic
      agoraListeners();

      // Join channel

      await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await engine.enableAudioVolumeIndication(500, 3, true);
      await engine.setDefaultAudioRoutetoSpeakerphone(true);

      await engine.setClientRole(ClientRole.Broadcaster);
      await engine.joinChannel(token, roomId, null, 0);
    } catch (e, s) {
      printOut('error joining room $e $s');
    }
  }

  void agoraListeners() {
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      printOut('joinChannelSuccess $channel $uid');
      userJoinedRoom.value = true;
    }, userJoined: (int uid, int elapsed) {
      printOut('userJoined $uid');
    }, userOffline: (int uid, UserOfflineReason reason) {
      printOut('userOffline $uid');
    }));
  }
}

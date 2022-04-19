import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/main.dart';
import 'package:fluttergistshop/models/event_model.dart' as event;
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_images_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/home/main_page.dart';
import 'package:fluttergistshop/screens/room/room_page.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/services/firestore_files_access_service.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'auth_controller.dart';

class RoomController extends FullLifeCycleController with FullLifeCycleMixin {
  RtcEngineContext context = RtcEngineContext(agoraAppID);
  late RtcEngine engine;
  var onChatPage = false.obs;

  var currentProfile = "".obs;
  var profileLoading = false.obs;
  var isLoading = false.obs;
  var isSwitched = false.obs;
  var allUsersLoading = false.obs;
  var moreUsersLoading = false.obs;
  var allUsers = [].obs;
  var searchedUsers = [].obs;
  var friendsToInvite = [].obs;
  var searchedfriendsToInvite = [].obs;
  var isCurrentRoomLoading = false.obs;
  var roomsList = [].obs;
  var eventsList = [].obs;
  var currentRoom = RoomModel().obs;
  var isCreatingRoom = false.obs;
  var newRoom = RoomModel().obs;
  var toInviteUsers = [].obs;
  var audioMuted = true.obs;

  var newRoomTitle = " ".obs;
  Rxn<DateTime> eventDate = Rxn<DateTime>(null);
  var resourceIdV = "".obs;
  var resourceSid = "".obs;
  var recordinguid = "".obs;
  var newRoomType = "public".obs;
  var selectedEvents = "all".obs;
  var agoraToken = "".obs;

  var roomPickedProduct = Product().obs;

  var roomHosts = <UserModel>[].obs;
  // var eventHosts = <OwnerId>[].obs;
  var roomShopId = "".obs;
  var roomProductImages = [].obs;

  var userProducts = [].obs;
  var userProductsLoading = false.obs;
  var userJoinedRoom = false.obs;
  var isSearching = false.obs;
  var usersPageNumber = 0.obs;
  final usersScrollController = ScrollController();

  var roomPickedImages = [].obs;

  TextEditingController searchUsersController = TextEditingController();
  TextEditingController roomTitleController = TextEditingController();
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventDescriptiion = TextEditingController();

  searchUsersWeAreFriends(String text) async {
    if (searchUsersController.text.trim().isNotEmpty) {
      try {
        allUsersLoading.value = true;
        var results = await UserAPI.searchFriends(text);
        searchedfriendsToInvite.assignAll(results);
        allUsersLoading.value = false;
      } catch (e) {
        printOut(e.toString());
        allUsersLoading.value = false;
      }
    }
  }

  Future<void> friendsToInviteCall() async {
    print("friendsToInviteCall");

    try {
      allUsersLoading.value = true;

      var users = await UserAPI.friendsToInvite();
      var list = [];

      if (users != null) {
        for (var i = 0; i < users.length; i++) {
          if (users.elementAt(i)["_id"] !=
              FirebaseAuth.instance.currentUser!.uid) {
            list.add(users.elementAt(i));
          }
        }
        friendsToInvite.value = list;
      } else {
        friendsToInvite.value = [];
      }
      searchedfriendsToInvite.value = friendsToInvite;

      friendsToInvite.refresh();
      allUsersLoading.value = false;
    } catch (e) {
      printOut(e);
      allUsersLoading.value = false;
    }
  }

  // Mandatory
  @override
  void onDetached() {
    print('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    print('HomeController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('HomeController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() {
    print('HomeController - onResumed called');
  }

  // Optional
  @override
  Future<bool> didPushRoute(String route) {
    print('HomeController - the route $route will be open');
    return super.didPushRoute(route);
  }

  // Optional
  @override
  Future<bool> didPopRoute() {
    print('HomeController - the current route will be closed');
    return super.didPopRoute();
  }

  // Optional
  @override
  void didChangeMetrics() {
    print('HomeController - the window size did change');
    super.didChangeMetrics();
  }

  // Optional
  @override
  void didChangePlatformBrightness() {
    print('HomeController - platform change ThemeMode');
    super.didChangePlatformBrightness();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var headers;
  @override
  void onClose() {
    print("onClose");
    leaveRoomWhenKilled();
    leaveAgora();
    super.onClose();
  }

  @override
  void onInit() {
    _initAgora();
    getRooms();

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    var authorizationHeader =
        "Basic " + stringToBase64.encode(agoraAppRecordKey);
    headers = {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': authorizationHeader
    };
    super.onInit();

    userScrollControllerListener();

    printOut("room controller");
  }

  void userScrollControllerListener() {

    usersScrollController.addListener(() {
      if (usersScrollController.position.atEdge) {
        bool isTop = usersScrollController.position.pixels == 0;
        printOut('current position controller ' + usersScrollController.position.pixels.toString());
        if (isTop) {
          printOut('At the top');
        } else {
          printOut('At the bottom');
          usersPageNumber.value = usersPageNumber.value + 1;
          fetchMoreUsers();
        }
      }
    });
  }

  _initAgora() async {
    // Get microphone permission
    // await [Permission.microphone].request();

    // Create RTC client instance
    engine = await RtcEngine.createWithContext(context);

    // Define event handling logic
    agoraListeners();

    // Join channel
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.enableAudioVolumeIndication(500, 3, true);
    await engine.enableAudio();
    await engine.muteLocalAudioStream(audioMuted.value);
    await engine.setDefaultAudioRouteToSpeakerphone(true);

    await engine.setClientRole(ClientRole.Broadcaster);
  }

  getRooms() async {
    await fetchRooms();
    printOut(roomsList.length);
  }

  Future<void> createRoom() async {
    try {
      isCreatingRoom.value = true;

      Get.defaultDialog(
          title: "Going live...",
          contentPadding: EdgeInsets.all(10),
          content: const CircularProgressIndicator(),
          barrierDismissible: false);

      var hosts = [];
      for (var element in roomHosts) {
        hosts.add(element.id);
      }

      String roomTitle =
          roomTitleController.text.isEmpty ? " " : roomTitleController.text;

      var roomData = {
        "title": roomTitle,
        "roomType": newRoomType.value,
        "productIds": [roomPickedProduct.value.id],
        "hostIds": hosts,
        "userIds": [],
        "raisedHands": [],
        "speakerIds": [],
        "invitedIds": [],
        "shopId": Get.find<AuthController>().usermodel.value!.shopId!.id,
        "status": true,
        "productPrice": roomPickedProduct.value.price,
        "productImages": roomPickedProduct.value.images,
        "activeTime": DateTime.now().microsecondsSinceEpoch
      };

      print("roomData $roomData");

      leaveRoom(OwnerId(id: Get.find<AuthController>().usermodel.value!.id));

      var rooms = await RoomAPI().createARoom(roomData);

      printOut("room created $rooms");

      if (rooms != null) {
        var roomId = rooms["_id"];
        var token = await RoomAPI().generateAgoraToken(roomId, "0");
        printOut("room token $token");
        roomTitleController.text = "";

        if (token != null) {
          printOut("room title ${roomData["title"]}");
          await RoomAPI().updateRoomById({
            "title": roomData["title"],
            "token": token,
            "activeTime": DateTime.now().microsecondsSinceEpoch
          }, roomId);

          await fetchRoom(roomId);

          initAgora(token, roomId);
          uploadImageToFireStorage(roomId);

          Get.offAll(MainPage());
          Get.to(RoomPage(roomId: roomId));
        } else {
          Get.offAll(MainPage());
          Get.snackbar(
              "", "There was an error creating your room. Try again later",
              backgroundColor: sc_snackBar, colorText: Colors.white);

          endRoom(roomId);
        }
      } else {
        Get.offAll(MainPage());
        Get.snackbar("", "Error creating your room",
            backgroundColor: sc_snackBar, colorText: Colors.white);
      }

      isCreatingRoom.value = false;

      update();
    } catch (e, s) {
      Get.back();
      printOut("Error creating room in controller $e $s");
      isCreatingRoom.value = false;
    }
  }

  createRoomFromEvent(event.EventModel eventModel) async {
    try {
      isCreatingRoom.value = true;

      Get.defaultDialog(
          title: "Going live...",
          contentPadding: EdgeInsets.all(10),
          content: const CircularProgressIndicator(),
          barrierDismissible: false);

      leaveRoom(OwnerId(id: Get.find<AuthController>().usermodel.value!.id));

      printOut("room created $eventModel");

      if (eventModel != null) {
        var roomId = eventModel.id!;
        var token = await RoomAPI().generateAgoraToken(roomId, "0");
        printOut("room token $token");
        roomTitleController.text = "";

        if (token != null) {
          await RoomAPI().updateRoomByIdNew({
            "title": eventModel.title,
            "token": token,
            "roomType": eventModel.roomType,
            "event": false,
            "activeTime": DateTime.now().microsecondsSinceEpoch
          }, roomId);

          await fetchRoom(roomId);

          initAgora(token, roomId);
          uploadImageToFireStorage(roomId);

          Get.offAll(MainPage());
          Get.to(RoomPage(roomId: roomId));
        } else {
          Get.offAll(MainPage());
          Get.snackbar(
            "",
            "There was an error creating your room. Try again later",
            backgroundColor: sc_snackBar,
          );

          endRoom(roomId);
        }
      } else {
        Get.offAll(MainPage());
        Get.snackbar(
          "",
          "Error creating your room",
          backgroundColor: sc_snackBar,
        );
      }
    } catch (e, s) {
      Get.back();
      printOut("Error creating room in controller $e $s");
      isCreatingRoom.value = false;
    }
  }

  Future<void> uploadImageToFireStorage(String roomId) async {
    String snackBarMessage = "";

    try {
      List<String> uploadedImages = [];

      for (var i = 0; i < roomPickedImages.length; i++) {
        RoomImagesModel roomImagesModel = roomPickedImages.elementAt(i);

        if (roomImagesModel.isPath) {
          final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
              File(roomImagesModel.imageUrl), "rooms/$roomId");

          printOut(downloadUrl);
          uploadedImages.add(downloadUrl);
          currentRoom.value.productImages!.add(downloadUrl);
          currentRoom.refresh();
        }
      }

      await RoomAPI().updateRoomById({
        "title": currentRoom.value.title ?? " ",
        "token": currentRoom.value.token,
        "productImages": uploadedImages
      }, roomId);

      roomPickedImages.value = [];
    } on FirebaseException catch (e) {
      snackBarMessage = "Something went wrong ${e.toString()}";
    } catch (e) {
      snackBarMessage = "Something went wrong ${e.toString()}";
    } finally {
      GetSnackBar(
        title: "",
        backgroundColor: sc_snackBar,
        messageText: Text(
          snackBarMessage,
          style: const TextStyle(color: Colors.white),
        ),
      );
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

  fetchEvents() async {
    try {
      isLoading.value = true;
      eventsList.clear();
      var events = await RoomAPI().getAllEvents();
      eventsList.value = events;
      isLoading.value = false;
      return events;
      if (events != null) {
        eventsList.value = events;
      } else {
        eventsList.value = [];
      }
      print("eventsList ${eventsList.length}");
      isLoading.value = false;
      return eventsList;
    } catch (e) {
      isLoading.value = false;
    }
  }

  fetchMyEvents() async {
    try {
      isLoading.value = true;

      eventsList.clear();
      var events = await RoomAPI().getAllMyEvents();
      eventsList.value = events;
      isLoading.value = false;
      print("events ${events.length}");
      return events;
      if (events != null) {
        eventsList.value = events;
      } else {
        eventsList.value = [];
      }
      print("eventsList ${eventsList.length}");
      isLoading.value = false;
      return eventsList;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserCurrentRoom() async {
    try {
      isLoading.value = true;

      var room = await RoomAPI()
          .getRoomById(Get.find<AuthController>().usermodel.value!.id!);

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
        printOut("currentRoom token ${room.token}");
        if (room.token != null) {
          currentRoom.value = room;
        } else {
          Get.snackbar('',
                  "There was an error adding you to the room, Try again later",
                  backgroundColor: sc_snackBar, colorText: Colors.white)
              .show();
          endRoom(roomId);
        }
      } else {
        Get.snackbar('', "Room has ended",
            backgroundColor: sc_snackBar, colorText: Colors.white);
      }
      isCurrentRoomLoading.value = false;

      printOut("Room $roomResponse");
    } catch (e, s) {
      printOut("Error getting individual room $e $s");
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
        currentRoom.refresh();
        leaveRoomWhenKilled();
        emitRoom(currentUser: user.toJson(), action: "join");
        //Add user to room

        if (currentRoom.value.invitedhostIds!
                .indexWhere((element) => element == user.id) !=
            -1) {
          currentRoom.value.hostIds!.add(user);
          await RoomAPI().updateRoomById({
            "token": currentRoom.value.token,
            "hostIds": [user.id]
          }, currentRoom.value.id!);
        } else {
          currentRoom.value.userIds!.add(user);
          await RoomAPI().addUserrToRoom({
            "users": [user.id]
          }, currentRoom.value.id!);
        }
      }
    } else {
      roomsList.removeWhere((element) => element.id == currentRoom.value.id);
      Get.snackbar(
          '', "There was an error adding you to the room, Try again later",
          backgroundColor: sc_snackBar, colorText: Colors.white);
    }
  }

  Future<void> raiseHand(BuildContext context, OwnerId currentUser) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Raise hand"),
          content: const Text("Are you sure you want to raise your hand?"),
          actions: [
            FlatButton(
              child: const Text("Yes"),
              onPressed: () async {
                Navigator.pop(context, true);
                await addUserToRaisedHands(currentUser);
              },
            ),
            FlatButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  void leaveRoomWhenKilled() {
    print("leaveRommWhenKilled");
    if (Get.find<AuthController>().currentuser!.currentRoom! != "") {
      emitRoom(
          action: "leave",
          roomId: Get.find<AuthController>().currentuser!.currentRoom!,
          currentUser: Get.find<AuthController>().currentuser!.toJson());
      Get.find<AuthController>().currentuser!.currentRoom = "";
    }
  }

  Future<void> addUserToSpeaker(OwnerId user) async {
    currentRoom.value.userIds!.removeWhere((element) => element.id == user.id);
    currentRoom.value.raisedHands!
        .removeWhere((element) => element.id == user.id);

    if ((currentRoom.value.speakerIds!
            .indexWhere((element) => element.id == user.id) ==
        -1)) {
      currentRoom.value.speakerIds!.add(user);

      currentRoom.refresh();

      emitRoom(currentUser: user.toJson(), action: "add_speaker");
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
    }
    //Remove user from RaisedHand
    await RoomAPI().removeUserFromRaisedHandsInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> addUserToRaisedHands(OwnerId user) async {
    currentRoom.value.raisedHands!.add(user);

    Get.snackbar(
      '',
      "You have raised your hand",
      colorText: Colors.white,
      backgroundColor: sc_snackBar,
    );

    currentRoom.refresh();

    emitRoom(currentUser: user.toJson(), action: "added_raised_hands");

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

    emitRoom(currentUser: user.toJson(), action: "remove_speaker");
    //Add user to speakers
    await RoomAPI().updateRoomById({
      "title": currentRoom.value.title ?? " ",
      "userIds": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
    //Remove user from audience
    await RoomAPI().removeUserFromSpeakerInRoom({
      "users": [user.id]
    }, currentRoom.value.id!);
  }

  Future<void> removeUserFromRaisedHands(OwnerId user) async {
    currentRoom.value.raisedHands!
        .removeWhere((element) => element.id == user.id);
    currentRoom.value.userIds!.removeWhere((element) => element.id == user.id);

    if ((currentRoom.value.speakerIds!
            .indexWhere((element) => element.id == user.id) ==
        -1)) {
      currentRoom.value.speakerIds!.add(user);

      currentRoom.refresh();

      emitRoom(currentUser: user.toJson(), action: "add_speaker");
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
    }
    //Remove user from RaisedHand
    await RoomAPI().removeUserFromAudienceInRoom({
      "users": [user.id],
      "token": currentRoom.value.token
    }, currentRoom.value.id!);
  }

  Future<void> leaveRoom(OwnerId user, {String? idRoom}) async {
    // await stopRecording(
    //     channelname: currentRoom.value.id,
    //     resourceid: resourceIdV.value,
    //     uid: recordinguid.value,
    //     sid: resourceSid.value);
    if (currentRoom.value.hostIds!
            .indexWhere((element) => element.id == user.id) !=
        -1) {
      if (currentRoom.value.hostIds!.length == 1) {
        endRoom(idRoom ?? currentRoom.value.id!);
      } else {
        await RoomAPI().removeUserFromHostInRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
        emitRoom(
            currentUser: user.toJson(),
            action: "leave",
            roomId: idRoom ?? currentRoom.value.id!);
      }

      currentRoom.value = RoomModel();
    } else {
      if (currentRoom.value.userIds!
              .indexWhere((element) => element.id == user.id) !=
          -1) {
        await RoomAPI().removeAUserFromRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      } else if (currentRoom.value.speakerIds!
              .indexWhere((element) => element.id == user.id) !=
          -1) {
        await RoomAPI().removeUserFromSpeakerInRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      }
      if (currentRoom.value.raisedHands!
              .indexWhere((element) => element.id == user.id) !=
          -1) {
        await RoomAPI().removeUserFromRaisedHandsInRoom({
          "users": [user.id]
        }, idRoom ?? currentRoom.value.id!);
      }
    }

    var roomId = idRoom ?? currentRoom.value.id!;

    emitRoom(currentUser: user.toJson(), action: "leave", roomId: roomId);
    currentRoom.value = RoomModel();

    try {
      leaveAgora();
    } catch (e) {
      printOut("Error leaving agora");
    }
  }

  endRoom(String roomId) async {
    try {
      currentRoom.value = RoomModel();
      currentRoom.refresh();
      emitRoom(action: "room_ended", roomId: roomId);
      await RoomAPI().deleteARoom(roomId);
      leaveAgora();
    } catch (e, s) {
      printOut("Error ending room $e $s");
    }
  }

  Future<void> joinRoom(String roomId) async {
    if (Get.find<AuthController>().usermodel.value == null) {
      await UserAPI.getUserById();
      Get.find<AuthController>().usermodel.refresh();
    }

    OwnerId currentUser = OwnerId(
        id: Get.find<AuthController>().usermodel.value!.id,
        bio: Get.find<AuthController>().usermodel.value!.bio,
        email: Get.find<AuthController>().usermodel.value!.email,
        firstName: Get.find<AuthController>().usermodel.value!.firstName,
        lastName: Get.find<AuthController>().usermodel.value!.lastName,
        userName: Get.find<AuthController>().usermodel.value!.userName,
        followers: Get.find<AuthController>().usermodel.value!.followers,
        following: Get.find<AuthController>().usermodel.value!.following,
        profilePhoto: Get.find<AuthController>().usermodel.value!.profilePhoto);

    Get.defaultDialog(
        title: "Joining room...",
        contentPadding: const EdgeInsets.all(10),
        content: const CircularProgressIndicator(),
        barrierDismissible: false);

    if (currentRoom.value.id != null && currentRoom.value.id != roomId) {
      var prevRoom = currentRoom.value.id;
      currentRoom.value.id = null;
      await leaveRoom(currentUser, idRoom: prevRoom);

      currentRoom.value = RoomModel();
      currentRoom.refresh();
    }

    await fetchRoom(roomId);

    if (currentRoom.value.id != null) {
      Get.back();
      Get.to(() => RoomPage(
            roomId: roomId,
          ));
      await addUserToRoom(currentUser);
      if (currentRoom.value.token != null) {
        //If user is not a speaker or a host, disable their audio
        if (currentRoom.value.userIds!
                .indexWhere((e) => e.id == currentUser.id) ==
            -1) {
          try {
            await engine.enableAudio();
            await engine.enableLocalAudio(true);

            await engine.muteLocalAudioStream(audioMuted.value);
            currentRoom.refresh();
          } catch (e, s) {
            printOut("Error disabling audio $e $s");
          }
        } else {
          await engine.enableLocalAudio(false);
          await engine.muteLocalAudioStream(true);
        }
        // Get.back();
        // Get.to(() => RoomPage(
        //   roomId: roomId,
        // ));
      } else {
        Get.snackbar(
            '', "There was an error adding you to the room. Try again later.",
            backgroundColor: sc_snackBar, colorText: Colors.white);
        roomsList.removeWhere((element) => element.id == roomId);
      }
    } else {
      Get.snackbar('', "Room has ended",
          backgroundColor: sc_snackBar, colorText: Colors.white);
      Get.offAll(() => MainPage());
      await fetchRooms();
    }
  }

  void emitRoom(
      {Map? currentUser, required String action, String roomId = ""}) {
    print("action $action ${currentRoom.value.id} prev $roomId");
    if (action == "leave") {
      customSocketIO.socketIO.off(currentRoom.value.id ?? roomId);
    }

    customSocketIO.socketIO.emit("room_changes", {
      "action": action,
      "userData": currentUser ?? {},
      "roomId": currentRoom.value.id ?? roomId
    });
  }

  Future<void> leaveAgora() async {
    // if (engine != null) {

    await engine.leaveChannel();
    await engine.enableLocalAudio(false);
    await engine.muteLocalAudioStream(true);
    // await engine.destroy();
    // }
  }

  Future<void> fetchAllUsers() async {
      try {
        allUsersLoading.value = true;

        usersPageNumber.value = 0;
        var users = await UserAPI().getAllUsers(0);
        var list = [];

        if (users != null) {
          for (var i = 0; i < users.length; i++) {
            if (users.elementAt(i)["_id"] !=
                FirebaseAuth.instance.currentUser!.uid) {
              list.add(users.elementAt(i));
            }
          }
          allUsers.value = list;
        } else {
          allUsers.value = [];
        }
        searchedUsers.value = allUsers;

        allUsers.refresh();
        allUsersLoading.value = false;

        update();
      } catch (e) {
        printOut(e);
        allUsersLoading.value = false;
      }
  }

  Future<void> fetchMoreUsers() async {
    try {
      moreUsersLoading.value = true;

      var users = await UserAPI().getAllUsers(usersPageNumber.value);
      var list = [];

      if (users != null) {
        for (var i = 0; i < users.length; i++) {
          if (users.elementAt(i)["_id"] !=
              FirebaseAuth.instance.currentUser!.uid) {
            list.add(users.elementAt(i));
          }
        }
        allUsers.addAll(list);
        // searchedUsers.value = allUsers;
        searchedUsers.addAll(list);
        allUsers.refresh();
        moreUsersLoading.value = false;

        update();
      } else {
        moreUsersLoading.value = false;
        searchedUsers = allUsers;
      }

    } catch (e) {
      printOut(e);
      moreUsersLoading.value = false;
    }
  }

  searchUsers() async {
    if (searchUsersController.text.trim().isNotEmpty) {
      try {
        allUsersLoading.value = true;

        var users =
            await UserAPI().searchUser(searchUsersController.text.trim());

        var list = [];

        if (users != null) {
          for (var i = 0; i < users.length; i++) {
            if (users.elementAt(i)["_id"] !=
                FirebaseAuth.instance.currentUser!.uid) {
              list.add(users.elementAt(i));
            }
          }
          searchedUsers.value = list;
        } else {
          searchedUsers.value = [];
        }
        searchedUsers.refresh();
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
      userProducts.value = [];
      var products = await ProductPI()
          .getUserProducts(FirebaseAuth.instance.currentUser!.uid);

      if (products != null) {
        printOut(products.length);

        //if a product has images, add it to the user products list
        for (var i = 0; i < products.length; i++) {
          Product product = Product.fromJson(products.elementAt(i));
          printOut(product.images);
          userProducts.add(products.elementAt(i));

          /*   if (product.images != null && product.images!.isNotEmpty) {
            userProducts.add(products.elementAt(i));
          }*/
        }
        printOut(userProducts.length);
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

      await leaveAgora();
      _initAgora();
      await engine.joinChannel(token, roomId, null, 0);
      await engine.enableAudioVolumeIndication(500, 3, true);
      // recordAudio(token: token, channelname: roomId);

    } catch (e, s) {
      printOut('error joining room $e $s');
    }
  }

  // getResourceId({String? channelname, String? uid}) async {
  //   print("getResourceId");
  //   var response = await DbBase().databaseRequest(
  //       "https://api.agora.io/v1/apps/${agoraAppID}/cloud_recording/acquire",
  //       DbBase().postRequestType,
  //       body: {
  //         "cname": channelname,
  //         "uid": uid,
  //         "clientRequest": {"region": "CN", "resourceExpiredHour": 24}
  //       },
  //       headers: headers);
  //   return jsonDecode(response);
  // }

  // startRecording(
  //     {String? resourceid,
  //     String? channelname,
  //     String? uid,
  //     String? token}) async {
  //   print("startRecording");
  //   var body = {
  //     "cname": channelname,
  //     "uid": uid,
  //     "clientRequest": {
  //       "token": token,
  //       "recordingConfig": {
  //         "channelType": 0,
  //         "streamTypes": 2,
  //         "audioProfile": 1,
  //         "maxIdleTime": 45,
  //         "transcodingConfig": {
  //           "width": 360,
  //           "height": 640,
  //           "fps": 30,
  //           "bitrate": 600,
  //           "maxResolutionUid": "1",
  //           "mixedVideoLayout": 1
  //         },
  //         "recordingFileConfig": {
  //           "avFileType": ["hls", "mp4"]
  //         },
  //       },
  //       "storageConfig": {
  //         "vendor": 1,
  //         "region": 3,
  //         "bucket": "gistshopaudios",
  //         "accessKey": "AKIAWZXHGM4OSTZXTKXF",
  //         "secretKey": "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"
  //       }
  //     }
  //   };
  //
  //   var response = await DbBase().databaseRequest(
  //       "https://api.agora.io/v1/apps/${agoraAppID}/cloud_recording/resourceid/${resourceid}/mode/mix/start",
  //       DbBase().postRequestType,
  //       body: body,
  //       headers: headers);
  //   return jsonDecode(response);
  // }

  stopRecording(
      {String? channelname,
      String? uid,
      String? resourceid,
      String? sid}) async {
    print("stopRecording ${{channelname, resourceid}}");
    var body = {
      "resourceid": resourceid,
      "channelname": channelname,
      "uid": uid,
      "roomuid": [Get.find<AuthController>().usermodel.value!.roomuid]
    };
    print(body);
    print(headers);
    print(stoprecording + channelname!);
    var response = await DbBase().databaseRequest(
        stoprecording + sid!, DbBase().postRequestType,
        body: body, headers: headers);
    print("after stoping $response");
    return jsonDecode(response);
  }

  // recordAudio({String? channelname, String? token}) async {
  //   print("recordAudio");
  //   var rng = new Random();
  //   var code = rng.nextInt(900000) + 100000;
  //   String uid = code.toString();
  //   recordinguid.value = uid.toString();
  //   var resourceId = await getResourceId(channelname: channelname, uid: uid);
  //
  //   resourceIdV.value = resourceId["resourceId"];
  //   var startrecording = await startRecording(
  //       resourceid: resourceId["resourceId"],
  //       channelname: channelname,
  //       uid: uid,
  //       token: token);
  //   resourceSid.value = startrecording["sid"];
  //
  //   await RoomAPI().updateRoomByIdNew({
  //     "resourceId": resourceId["resourceId"],
  //     "recordingsid": startrecording["sid"],
  //     "recordingUid": uid,
  //   }, channelname!);
  //
  //   print("startrecording $startrecording");
  // }

  void agoraListeners() {
    // Define event handling logic
    engine.setEventHandler(
      RtcEngineEventHandler(error: (error) async {
        printOut("Error in agora ${error.name}");
        if (error.name == "InvalidToken" || error.name == "TokenExpired") {
          Get.back();
          roomsList
              .removeWhere((element) => element["_id"] == currentRoom.value.id);

          endRoom(currentRoom.value.id!);

          leaveAgora();
        }
      }, joinChannelSuccess: (String channel, int uid, int elapsed) {
        printOut('joinChannelSuccess $channel $uid');
        // if (authController.usermodel.value!.roomuid == "") {
        UserAPI()
            .updateUser({"roomuid": uid}, authController.usermodel.value!.id!);
        // }

        userJoinedRoom.value = true;
      }, userJoined: (int uid, int elapsed) async {
        printOut('userJoined $uid');
      }, userOffline: (int uid, UserOfflineReason reason) {
        printOut('userOffline $uid');
      }, audioVolumeIndication:
          (List<AudioVolumeInfo> speakers, int totalVolume) async {
        if (totalVolume > 2) {
          writeToDbRoomActive();
        }
      }, activeSpeaker: (int id) {
        print("active speaker $id");
      }),
    );
  }

  //If the last time the activeTime field was updated was more or equal to 10 mins ago, then update it
  writeToDbRoomActive() async {
    var now = DateTime.now();

    if (currentRoom.value.activeTime != null) {
      var lastUpdated =
          DateTime.fromMicrosecondsSinceEpoch(currentRoom.value.activeTime!);
      var duration = now.difference(lastUpdated);

      if (duration.inMinutes > activeRoomUpdatePeriod) {
        updateActiveTime(now);
      }
    } else {
      updateActiveTime(now);
    }
  }

  updateActiveTime(DateTime now) async {
    currentRoom.value.activeTime = now.microsecondsSinceEpoch;
    if (currentRoom.value.id != null &&
        currentRoom.value.hostIds!.indexWhere((element) =>
                element.id == FirebaseAuth.instance.currentUser!.uid) !=
            -1) {
      await RoomAPI().updateRoomById({
        "activeTime": now.microsecondsSinceEpoch,
        "title": currentRoom.value.title,
        "token": currentRoom.value.token
      }, currentRoom.value.id!);
    }
  }

  getUserProfile(String userId) async {
    try {
      profileLoading.value = true;
      var user = await UserAPI().getUserProfile(userId);

      if (user == null) {
        currentProfile.value = "";
      } else {
        currentProfile.value = user;
      }

      profileLoading.value = false;
    } catch (e, s) {
      printOut("Error getting user $userId profile $e $s");
    }
  }

  createEvent() async {
    try {
      isCreatingRoom.value = true;

      var hosts = [];
      for (var element in roomHosts) {
        hosts.add(element.id);
      }

      String roomTitle =
          eventTitleController.text.isEmpty ? " " : eventTitleController.text;

      var roomData = {
        "title": roomTitle,
        "roomType": newRoomType.value.isEmpty ? "public" : newRoomType.value,
        "productIds": [roomPickedProduct.value.id],
        "hostIds": hosts,
        "description": eventDescriptiion.text,
        "userIds": [],
        "raisedHands": [],
        "speakerIds": [],
        "event": true,
        "invitedIds": [],
        "shopId": Get.find<AuthController>().usermodel.value!.shopId!.id,
        "status": true,
        "productPrice": roomPickedProduct.value.price,
        "productImages": roomPickedProduct.value.images,
        "activeTime": DateTime.now().microsecondsSinceEpoch,
        "eventDate": eventDate.value!.millisecondsSinceEpoch
      };

      var rooms = await RoomAPI().createEvent(roomData);

      //send nootification to hosts eexcept me

      // hosts.forEach((element) async {
      //   await NotificationApi().sendNotification(
      //       [element.id],
      //       "${Get.find<AuthController>().usermodel.value!.firstName}"
      //           " ${Get.find<AuthController>().usermodel.value!.firstName}",
      //       "invited you to ${roomTitle} event",
      //       "ProfileScreen",
      //       Get.find<AuthController>().usermodel.value!.id!);
      // });

      if (rooms != null) {
        Get.back();
        eventTitleController.text = "";
        Get.snackbar(
          "",
          "Event created successfully",
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
          "",
          "Error creating your room",
          backgroundColor: sc_snackBar,
        );
      }
      isCreatingRoom.value = false;
    } catch (e, s) {
      printOut("Error creating room in controller $e $s");
      isCreatingRoom.value = false;
    }
  }

  updateEvent(String roomId, var data) async {
    await RoomAPI().updateRoomByIdNew(data, roomId);
  }

  void deleteEvent(String roomId) async {
    Get.defaultDialog(
        title: "Deleting event",
        contentPadding: EdgeInsets.all(10),
        content: const CircularProgressIndicator(),
        barrierDismissible: false);
    await RoomAPI().deleteARoom(roomId);
    fetchEvents();
    Get.back();
    Get.back();
  }

  startrecordingAudio({token, String? channelname}) async {
    Map<String, dynamic> response =
        await RoomAPI().recordRoom(channelname!, token);
    if (response.containsKey("message")) {
      print(response["message"]);
      Get.snackbar('', 'Start recording failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } else {
      currentRoom.value = RoomModel.fromJson(response);
      Get.snackbar('', 'Recoding started...',
          backgroundColor: sc_snackBar,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
    return response;
  }

  Future<void> sendRoomNotification(RoomModel roomModel) async {
    if (currentRoom.value.speakersSentNotifications!.indexWhere((element) =>
            element == Get.find<AuthController>().usermodel.value!.id) ==
        -1) {
      var response = await RoomAPI().sendRoomNotication({
        "user": Get.find<AuthController>().usermodel.value!.toJson(),
        "type": "speaking",
        "room": roomModel.toJson()
      });
      printOut("speakersSentNotifications ${response}");
      currentRoom.value = RoomModel.fromJson(response);
      currentRoom.refresh();
    }
  }
}

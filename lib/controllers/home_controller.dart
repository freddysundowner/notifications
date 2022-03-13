import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isCurrentRoomLoading = false.obs;
  var roomsList = [].obs;
  var currentRoom = RoomModel().obs;

  @override
  void onInit() {
    getRooms();
    super.onInit();
  }

  getRooms() async {
    await fetchRooms();
    printOut(roomsList.length);
  }

  Future<void> fetchRooms() async {

    try {
      isLoading.value = true;

      var rooms = await RoomAPI()
          .getAllRooms();

      if (rooms != null) {
        roomsList.value = rooms;
      }else{
        roomsList.value = [];
      }
      roomsList.refresh();
      isLoading.value = false;

      update();
    }catch(e) {
      printOut(e);
      isLoading.value = false;
    }
  }

  Future<void> fetchUserCurrentRoom() async {

    try {
      isLoading.value = true;

      var room = await RoomAPI()
          .getRoomById("61fb9094d59efb5046a99946");

      if (room != null) {
        currentRoom.value = RoomModel.fromJson(room);
      }

    }finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoom(String roomId) async {
    printOut("RoomId $roomId");

    try {
      isCurrentRoomLoading.value = true;

      var roomResponse = await RoomAPI()
          .getRoomById(roomId);

      if (roomResponse != null) {
        currentRoom.value = RoomModel.fromJson(roomResponse);
      }
      isCurrentRoomLoading.value = false;
      update();
      printOut("Room $roomResponse");

    }catch(e) {
      printOut("Error getting individual room " + e.toString() );
      isCurrentRoomLoading.value = false;
    }
  }

  Future<void> addUserToSpeaker(OwnerId user) async {

    currentRoom.value.speakerIds!.add(user);
    currentRoom.value.userIds!.remove(user);

    currentRoom.refresh();

    //Add user to speakers
    await RoomAPI().updateRoomById({
      "speakerIds": [user.id]
    }, currentRoom.value.id!);
    //Remove user from audience
    await RoomAPI().removeUserFromAudienceInRoom({
      "users": [user.id]
    }, currentRoom.value.id!);
  }

  Future<void> removeUserFromSpeaker(OwnerId user) async {

    currentRoom.value.speakerIds!.remove(user);
    currentRoom.value.userIds!.add(user);

    currentRoom.refresh();

    //Add user to speakers
    await RoomAPI().updateRoomById({
      "userIds": [user.id]
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
      "speakerIds": [user.id]
    }, currentRoom.value.id!);
    //Remove user from audience
    await RoomAPI().removeUserFromSpeakerInRoom({
      "speakerIds": [user.id]
    }, currentRoom.value.id!);
  }

  Future<void> leaveRoom(OwnerId user) async {

    currentRoom.value.speakerIds!.add(user);
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

  }

}
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var roomsList = [].obs;
  var currentRoom = "".obs;

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
      isLoading = false.obs;

      var rooms = await RoomAPI()
          .getAllRooms();

      if (rooms != null) {
        roomsList.value = rooms;
      }else{
        roomsList.value = [];
      }
      roomsList.refresh();
      isLoading = false.obs;

      update();
    }catch(e) {
      printOut(e);
      isLoading = false.obs;
    }
  }

  Future<void> fetchUserCurrentRoom() async {

    try {
      isLoading = true.obs;

      var room = await RoomAPI()
          .getRoomById("61fb9094d59efb5046a99946");

      if (room != null) {
        currentRoom.value = room;
      }

    }finally {
      isLoading = false.obs;
    }
  }

}
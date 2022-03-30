import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  late IO.Socket socketIO;

  final RoomController _roomController = Get.put(RoomController());

  IO.Socket init(
      {onSocketConnected,
      onAddToSpeakerResponse,
      onUserJoinedResponse,
      onUserLeftResponse,
      onMoveToAudienceResponse,
      onAddToRaisedHandsResponse,
        onDisconnected}) {

    socketIO = IO.io("http://52.43.151.113:5000", <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false
    });

    socketIO.connect();
    socketIO.on("connect", (data) {
      printOut("Connection Successfully Established...");
      onSocketConnected(socketIO);
    });

    socketIO.on("message", (data) {
      printOut("there is response $data");
      onUserJoinedResponse(data);
    });

    socketIO.on("user_left_${_roomController.currentRoom.value.id}", (data) {
      printOut("there is response");
      onUserLeftResponse(data);
    });

    socketIO.on("user_to_speaker_${_roomController.currentRoom.value.id}", (data) {
      printOut("there is response");
      onAddToSpeakerResponse(data);
    });

    socketIO.on("user_to_audience_${_roomController.currentRoom.value.id}", (data) {
      printOut("there is response");
      onMoveToAudienceResponse(data);
    });

    socketIO.on("user_to_raised_hands_${_roomController.currentRoom.value.id}", (data) {
      printOut("there is response");
      onAddToRaisedHandsResponse(data);
    });

    socketIO.on("reconnect", (data) {
      printOut("Socket Connected Again.. Reconnection");
    });

    socketIO.on("disconnect", (data) {
      print("Socket Disconnected Unexpectedly..");
      onDisconnected(data);
    });

    return socketIO;
  }
}

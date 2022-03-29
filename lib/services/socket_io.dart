import 'package:fluttergistshop/utils/functions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  late IO.Socket socketIO;

  IO.Socket init(onSocketConnected, onAddToSpeakerResponse,
      onUserJoinedResponse, onUserLeftResponse, onMoveToAudienceResponse,
      onAddToRaisedHandsResponse) {

    socketIO = IO.io("http://192.168.0.105:3000", <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false
    });

    socketIO.connect();
    socketIO.on("connect", (data) {
      printOut("Connection Successfully Established...");
      onSocketConnected(socketIO);
    });

    socketIO.on("user_joined", (data) {
      printOut("there is response");
      onUserJoinedResponse(data);
    });

    socketIO.on("user_left", (data) {
      printOut("there is response");
      onUserLeftResponse(data);
    });

    socketIO.on("user_to_speaker", (data) {
      printOut("there is response");
      onAddToSpeakerResponse(data);
    });

    socketIO.on("user_to_audience", (data) {
      printOut("there is response");
      onMoveToAudienceResponse(data);
    });

    socketIO.on("user_to_raised_hands", (data) {
      printOut("there is response");
      onAddToRaisedHandsResponse(data);
    });

    socketIO.on("reconnect", (data) {
      printOut("Socket Connected Again.. Reconnection");
    });

    socketIO.on("disconnect", (data) {
      printOut("Socket Disconnected Unexpectedly..");
      // onSocketDisconnected(socketIO);
    });

    return socketIO;
  }
}

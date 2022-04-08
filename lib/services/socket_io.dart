import 'package:fluttergistshop/utils/functions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CustomSocketIO {
  late IO.Socket socketIO;

  IO.Socket init(
      {onSocketConnected,
      onAddToSpeakerResponse,
      onUserJoinedResponse,
      onUserLeftResponse,
      onMoveToAudienceResponse,
      onAddToRaisedHandsResponse,
      onDisconnected}) {
    _connectSocket(onSocketConnected);

    socketIO.on("reconnect", (data) {
      printOut("Socket Connected Again.. Reconnection");
    });

    socketIO.on("disconnect", (data) {
      try {
        _connectSocket(onSocketConnected);
      } catch (e, s) {
        printOut("Error on disconnecting socket $e $s");
      }
    });

    return socketIO;
  }

  void _connectSocket(onSocketConnected) {
    socketIO = IO.io("http://52.43.151.113:5000", <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false,
      'forceNew': true,
    });
    socketIO.connect();
    socketIO.on("connect", (data) {
      printOut("Connection Successfully Established...");
      onSocketConnected(socketIO);
    });
  }
}

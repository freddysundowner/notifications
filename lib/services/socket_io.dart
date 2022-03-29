import 'package:fluttergistshop/services/configs.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  late IO.Socket socketIO;

  IO.Socket init({onSocketConnected, onAddToSpeakerResponse,onDisconnected}) {
    socketIO = IO.io(api_url, <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false
    });

    socketIO.connect();
    socketIO.on("connect", (data) {
      print("Connection Successfully Established...");
      onSocketConnected(socketIO);
    });
    socketIO.on("user-joined", (data) {
      print("there is response");
      onAddToSpeakerResponse(data);
    });

    socketIO.on("reconnect", (data) {
      print("Socket Connected Again.. Reconnection");
    });

    socketIO.on("disconnect", (data) {
      print("Socket Disconnected Unexpectedly..");
      onDisconnected(data);
    });

    return socketIO;
  }
}

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  late IO.Socket socketIO;

  IO.Socket init(onSocketConnected, onAddToSpeakerResponse) {
    socketIO = IO.io("http://192.168.0.105:3000", <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false
    });

    socketIO.connect();
    socketIO.on("connect", (data) {
      print("Connection Successfully Established...");
      onSocketConnected(socketIO);
    });
    socketIO.on("add-to-speaker-response", (data) {
      print("there is response");
      onAddToSpeakerResponse(data);
    });

    socketIO.on("reconnect", (data) {
      print("Socket Connected Again.. Reconnection");
    });

    socketIO.on("disconnect", (data) {
      print("Socket Disconnected Unexpectedly..");
      // onSocketDisconnected(socketIO);
    });

    return socketIO;
  }
}

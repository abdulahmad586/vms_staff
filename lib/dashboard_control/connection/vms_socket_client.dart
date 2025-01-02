import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

class VMSSocketClient {
  Function(dynamic)? onConnectionError;
  Function(bool)? connectionChange;
  String url;

  bool connected;

  io.Socket? socket;

  VMSSocketClient(
      {this.onConnectionError,
      this.connectionChange,
      required this.url,
      this.connected = false}) {
    connect();
  }

  /*'connect',
  'connect_error',
  'connect_timeout',
  'connecting',
  'disconnect',
  'error',
  'reconnect',
  'reconnect_attempt',
  'reconnect_failed',
  'reconnect_error',
  'reconnecting',
  'ping',
  'pong'*/

  connect() {
    print("Socket url:$url");
    socket = io.io(
        url,
        OptionBuilder()
            .setPath('/socket.io/')
            // .setExtraHeaders({'auth':{'x-access-token':apiToken}})
            .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
            .build());
    // socket = io.io(
    //   url,
    // );

    socket?.onConnect((_) {
      connected = true;
      print("Dashboard Socket connected!");
      if (connectionChange != null) {
        connectionChange!(true);
      }
    });

    if (onConnectionError != null) {
      connected = false;
      socket?.on('connect_error', onConnectionError!);
      socket?.on(
          'connect_timeout', (_) => onConnectionError!('Connection timed out'));
      socket?.on('error', onConnectionError!);
      socket?.on('reconnect_error', onConnectionError!);
    }

    socket?.onDisconnect((_) {
      connected = false;
      if (connectionChange != null) {
        connectionChange!(false);
        print("Dashboard Socket disconnected!");
      }
    });
  }

  emit(String event, dynamic data) {
    socket?.emit(event, data);
    print(
        "Emmitting $event, is socket null? ${socket == null} | is socket connected? $connected");
  }

  listen(String event, Function(dynamic) onEvent) {
    socket?.on(event, onEvent);
  }

  unlisten(String event) {
    socket?.off(event);
  }

  void closeConnection() {
    if (socket != null) {
      socket?.disconnect();
      socket?.close();
    }
  }
}

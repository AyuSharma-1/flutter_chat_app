import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket _socket;
  final _storage = FlutterSecureStorage();
  bool _isInitialized = false;

  SocketService._internal() {
    initSocket();
  }

  Future<void> initSocket() async {
    if (_isInitialized) return;

    String token = await _storage.read(key: 'token') ?? '';
    print(
      'Socket: Initializing with token: ${token.isNotEmpty ? "present" : "missing"}',
    );

    _socket = IO.io(
      'http://localhost:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket.onConnect((_) {
      print('Socket: Connected with id: ${_socket.id}');
      _isInitialized = true;
    });

    _socket.onDisconnect((_) {
      print('Socket: Disconnected');
    });

    _socket.onConnectError((error) {
      print('Socket: Connection error: $error');
    });

    _socket.onError((error) {
      print('Socket: Error: $error');
    });

    _socket.connect();
  }

  IO.Socket get socket => _socket;

  bool get isConnected => _socket.connected;
}

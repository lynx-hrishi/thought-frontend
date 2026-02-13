import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  bool _initialized = false;

  factory SocketService() => _instance;

  SocketService._internal();

  void init(String userId) {
    if (_initialized) return;

    socket = IO.io(
      'https://thoughtdrop-backend.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
      socket.emit('register', userId);
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
    socket.onConnectError((data) => print('Socket connection error: $data'));
    socket.onError((data) => print('Socket error: $data'));

    _initialized = true;
  }

  void sendMessage({
    required String recipientUserId,
    required String message,
    required String messageId,
    required int timestamp,
  }) {
    socket.emit('send-message', {
      'recipientUserId': recipientUserId,
      'message': message,
      'messageId': messageId,
      'timestamp': timestamp,
    });
  }

  void messageDeliveredAck({
    required String messageId,
    required String senderId,
  }) {
    socket.emit('message-delivered-ack', {
      'messageId': messageId,
      'senderId': senderId,
    });
  }

  void messageRead({
    required String messageId,
    required String senderId,
  }) {
    socket.emit('message-read', {
      'messageId': messageId,
      'senderId': senderId,
    });
  }

  void dispose() {
    socket.dispose();
    _initialized = false;
  }
}

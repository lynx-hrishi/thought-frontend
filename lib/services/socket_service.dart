import 'package:currency_converter/services/chat_storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import '../pages/chat_page.dart';
import '../http_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  bool _initialized = false;
  String? _currentUserId;
  Function(Map<String, dynamic>)? onMessageReceived;

  factory SocketService() => _instance;

  SocketService._internal();

  Future<void> init(String userId) async {
    if (_initialized && _currentUserId == userId) return;

    _currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('socket_user_id', userId);

    socket = IO.io(
      'https://thoughtdrop-backend.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
      socket.emit('register', userId);
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onReconnect((_) {
      print('Socket reconnected');
      socket.emit('register', userId);
    });

    socket.on('receive-message', (data) async {
      print('Global receive-message: $data');
      try {
        if (onMessageReceived != null) {
          onMessageReceived!(data);
        } else {
          print('Notification active');
          
          String senderName = 'New Message';
          try {
            final matchedUsers = await HttpService().getMatchedUsersService();
            final sender = matchedUsers.firstWhere(
              (user) => user['_id'] == data['senderId'],
              orElse: () => null,
            );
            if (sender != null) {
              senderName = sender['name'] ?? 'New Message';
            }
          } catch (e) {
            print('Failed to fetch sender name: $e');
          }
          
          await NotificationService().showMessageNotification(
            title: senderName,
            body: data['message'] ?? 'You have a new message',
            senderId: data['senderId'] ?? '',
          );
          
          print("Now starting to save");
          final newMessage = ChatMessage(
            messageId: data['messageId'], 
            text: data['message'], 
            timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? DateTime.now().millisecondsSinceEpoch), 
            isSent: false, 
            status: MessageStatus.delivered
          );
          
          final chatStorageService = ChatStorageService(userId: data['senderId']);
          final messages = await chatStorageService.loadMessages();
          messages.add(newMessage);
          chatStorageService.saveMessages(messages).catchError((e) {
            print('Failed to save received message: $e');
          });
        }
      } catch (e) {
        print('Error handling global message: $e');
      }
    });

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

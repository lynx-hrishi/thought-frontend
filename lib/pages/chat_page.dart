import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/chat_storage_service.dart';
import '../services/socket_service.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String currentUserId;
  
  const ChatPage({super.key, required this.userId, required this.userName, required this.currentUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatStorageService _storageService;
  late final SocketService _socketService;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _storageService = ChatStorageService(userId: widget.userId);
    _socketService = SocketService();
    _loadMessages();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socketService.socket.on('message-sent', (data) {
      print('Message sent: $data');
      _updateMessageStatus(data['messageId'], MessageStatus.sent);
    });

    _socketService.socket.on('message-delivered', (data) {
      print('Message delivered: $data');
      _updateMessageStatus(data['messageId'], MessageStatus.delivered);
    });

    _socketService.socket.on('message-read', (data) {
      print('Message read: $data');
      _updateMessageStatus(data['messageId'], MessageStatus.read);
    });

    _socketService.socket.on('receive-message', (data) {
      if (!mounted) return;
      print('Received message: $data');
      final message = ChatMessage(
        messageId: data['messageId'],
        text: data['message'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
        isSent: false,
        status: MessageStatus.delivered,
      );
      setState(() => _messages.add(message));
      _storageService.saveMessages(_messages);
      
      _socketService.messageDeliveredAck(
        messageId: data['messageId'],
        senderId: data['senderId'],
      );
      
      _scrollToBottom();
      _markMessagesAsRead();
    });
  }

  void _markMessagesAsRead() {
    for (var message in _messages) {
      if (!message.isSent && message.status != MessageStatus.read) {
        _socketService.messageRead(
          messageId: message.messageId,
          senderId: widget.userId,
        );
      }
    }
  }

  void _updateMessageStatus(String messageId, MessageStatus status) {
    if (!mounted) return;
    setState(() {
      final index = _messages.indexWhere((m) => m.messageId == messageId);
      if (index != -1) {
        _messages[index] = _messages[index].copyWith(status: status);
        _storageService.saveMessages(_messages);
      }
    });
  }

  Future<void> _loadMessages() async {
    final messages = await _storageService.loadMessages();
    setState(() => _messages = messages);
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    
    final messageId = const Uuid().v4();
    final message = ChatMessage(
      messageId: messageId,
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
      isSent: true,
      status: MessageStatus.sending,
    );
    
    setState(() => _messages.add(message));
    await _storageService.saveMessages(_messages);
    _controller.clear();
    
    print('Sending message: $messageId to ${widget.userId}');
    _socketService.sendMessage(
      recipientUserId: widget.userId,
      message: message.text,
      messageId: messageId,
      timestamp: message.timestamp.millisecondsSinceEpoch,
    );
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _messages.clear());
      await _storageService.clearMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') _clearChat();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Chat'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('No messages yet'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: message.isSent ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(color: message.isSent ? Colors.white : Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatTime(message.timestamp),
                                    style: TextStyle(
                                      color: message.isSent ? Colors.white70 : Colors.black54,
                                      fontSize: 10,
                                    ),
                                  ),
                                  if (message.isSent) const SizedBox(width: 4),
                                  if (message.isSent) Icon(
                                    message.status == MessageStatus.read
                                        ? Icons.done_all
                                        : message.status == MessageStatus.delivered
                                            ? Icons.done_all
                                            : message.status == MessageStatus.sent
                                                ? Icons.done
                                                : Icons.access_time,
                                    size: 14,
                                    color: message.status == MessageStatus.read
                                        ? Colors.blue[300]
                                        : Colors.white70,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  @override
  void dispose() {
    _socketService.socket.off('message-sent');
    _socketService.socket.off('message-delivered');
    _socketService.socket.off('message-read');
    _socketService.socket.off('receive-message');
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String messageId;
  final String text;
  final DateTime timestamp;
  final bool isSent;
  final MessageStatus status;

  ChatMessage({
    required this.messageId,
    required this.text,
    required this.timestamp,
    required this.isSent,
    required this.status,
  });

  ChatMessage copyWith({
    String? messageId,
    String? text,
    DateTime? timestamp,
    bool? isSent,
    MessageStatus? status,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isSent: isSent ?? this.isSent,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
    'isSent': isSent,
    'status': status.index,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: json['messageId'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
    isSent: json['isSent'],
    status: MessageStatus.values[json['status']],
  );
}

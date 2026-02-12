import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../pages/chat_page.dart';

class ChatStorageService {
  final String userId;
  
  ChatStorageService({required this.userId});
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final dir = Directory('$path/chats');
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('$path/chats/$userId.json');
  }

  Future<List<ChatMessage>> loadMessages() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((e) => ChatMessage.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final file = await _localFile;
    final jsonData = messages.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  Future<void> clearMessages() async {
    final file = await _localFile;
    if (await file.exists()) await file.delete();
  }
}

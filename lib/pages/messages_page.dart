import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../http_service.dart';
import '../utils/error_handler.dart';
import '../widgets/dio_image.dart';
import '../services/socket_service.dart';
import './chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List matchedUsers = [];
  bool isLoading = true;
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _initSocket();
    _loadMatchedUsers();
  }

  Future<void> _initSocket() async {
    try {
      final user = await HttpService().getUserDetails();
      currentUserId = user.id;
      await SocketService().init(currentUserId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _loadMatchedUsers() async {
    try {
      final users = await HttpService().getMatchedUsersService();
      setState(() {
        matchedUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getErrorMessage(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mail_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No matches yet',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: matchedUsers.length,
                  itemBuilder: (context, index) {
                    final user = matchedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: DioImage(user['profileImageUrl']),
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                      title: Text(
                        user['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Tap to chat',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              userId: user['_id'],
                              userName: user['name'],
                              currentUserId: currentUserId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

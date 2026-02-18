import 'package:currency_converter/http_service.dart';
import 'package:currency_converter/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../theme.dart';
import 'user_card.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<UserModel> users = [];
  int currentIndex = 0;
  final HttpService _httpService = HttpService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try{
      final fetchedUsers = await _httpService.getMatchesForUsers();
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    }
    catch(err){
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getErrorMessage(err))),
        );
      }
    }
  }

  void onLike() async {
    if (currentIndex < users.length) {
      try {
        bool hasMatched = await _httpService.likeUserService(users[currentIndex].id);
        if (hasMatched && mounted) {
          _showMatchDialog(users[currentIndex]);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(getErrorMessage(e))),
          );
        }
      }
    }
    if (currentIndex < users.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      setState(() {
        currentIndex++;
      });
    }
  }

  void onReject() async {
    if (currentIndex < users.length) {
      try {
        await _httpService.passUserService(users[currentIndex].id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(getErrorMessage(e))),
          );
        }
      }
    }
    if (currentIndex < users.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _showMatchDialog(UserModel matchedUser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite,
                color: AppTheme.lavender,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                "It's a Match!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You and ${matchedUser.name} liked each other!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continue Swiping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
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
      body: currentIndex >= users.length
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_outline,
                    size: 64,
                    color: AppTheme.lavender,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No more profiles',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for more matches',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: UserCard(
                    key: ValueKey(currentIndex),
                    user: users[currentIndex],
                    onLike: onLike,
                    onReject: onReject,
                  ),
                ),
              ],
            ),
    );
  }
}

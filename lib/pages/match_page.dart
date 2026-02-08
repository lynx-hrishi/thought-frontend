import 'package:currency_converter/http_service.dart';
import 'package:currency_converter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../models/dummy_data_provider.dart';
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
  HttpService _httpService = HttpService();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    }
  }

  void onLike() {
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

  void onReject() {
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
                    color: AppTheme.pink,
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

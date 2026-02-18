import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../http_service.dart';
import '../models/user_model.dart';
import '../theme.dart';
import '../utils/error_handler.dart';
import '../widgets/dio_image.dart';
import '../login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;
  bool isLoading = true;
  int imageRefreshKey = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userData = await HttpService().getUserDetails();
      setState(() {
        user = userData;
        isLoading = false;
        imageRefreshKey++;
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

  String _getZodiacEmoji(String zodiacSign) {
    switch (zodiacSign) {
      case 'ARIES': return '♈';
      case 'TAURUS': return '♉';
      case 'GEMINI': return '♊';
      case 'CANCER': return '♋';
      case 'LEO': return '♌';
      case 'VIRGO': return '♍';
      case 'LIBRA': return '♎';
      case 'SCORPIO': return '♏';
      case 'SAGITTARIUS': return '♐';
      case 'CAPRICORN': return '♑';
      case 'AQUARIUS': return '♒';
      case 'PISCES': return '♓';
      default: return '';
    }
  }

  Future<void> _logout() async {
    await HttpService().logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Failed to load profile',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(user: user!),
                  ),
                );
                if (result == true) {
                  _loadUserProfile();
                }
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: user!.images.length,
                itemBuilder: (context, index) {
                  return Image(
                    image: DioImage(user!.images[index], cacheKey: imageRefreshKey),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Failed to load image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Age
                  Text(
                    '${user!.name}',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${user!.age}, ${user!.gender}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_getZodiacEmoji(user!.zodiacSign)} ${user!.zodiacSign}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Profession
                  Text(
                    user!.profession,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        user!.email,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Interests
                  Text(
                    'Interests',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user!.interests
                        .map(
                          (interest) => Chip(
                            label: Text(
                              interest,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            backgroundColor: AppTheme.lavender.withOpacity(0.2),
                            labelStyle: const TextStyle(
                              color: AppTheme.lavender,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  // Partner Preference
                  if (user!.partnerPreference != null)
                    Text(
                      'Your Ideal Date Expectation',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (user!.partnerPreference != null)
                    const SizedBox(height: 8),
                  if (user!.partnerPreference != null)
                    Text(
                      user!.partnerPreference!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

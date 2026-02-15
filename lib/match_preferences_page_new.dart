import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'http_service.dart';
import 'pages/dashboard_page.dart';
import 'page_transition.dart';

class MatchPreferencesPage extends StatefulWidget {
  final String name;
  final String bio;
  final String gender;
  final String dateOfBirth;
  final String zodiacSign;
  final String profession;
  final List<String> interests;
  final File profileImage;
  final List<File> postImages;

  const MatchPreferencesPage({
    super.key,
    required this.name,
    required this.bio,
    required this.gender,
    required this.dateOfBirth,
    required this.zodiacSign,
    required this.profession,
    required this.interests,
    required this.profileImage,
    required this.postImages,
  });

  @override
  State<MatchPreferencesPage> createState() => _MatchPreferencesPageState();
}

class _MatchPreferencesPageState extends State<MatchPreferencesPage> {
  final PageController _pageController = PageController();
  final TextEditingController dateExpectationCtrl = TextEditingController();
  int currentPage = 0;

  String lookingFor = "Female";
  RangeValues ageRange = const RangeValues(18, 30);
  double distance = 20;

  void nextPage() {
    if (currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    }
  }

  void backPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    }
  }

  void finish() async {
    try {
      await HttpService().setUserPreferenceService(
        widget.name,
        widget.gender,
        widget.dateOfBirth,
        widget.zodiacSign,
        widget.profession,
        widget.interests,
        lookingFor,
        dateExpectationCtrl.text.trim(),
        ageRange.start.toInt(),
        ageRange.end.toInt(),
        widget.profileImage,
        widget.postImages,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          SlidePageRoute(page: const DashboardPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    dateExpectationCtrl.dispose();
    super.dispose();
  }

  Widget stepDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentPage == i ? 26 : 8,
          decoration: BoxDecoration(
            color: currentPage == i
                ? const Color(0xFF7E57C2)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget optionCard(String emoji, String title) {
    final bool selected = lookingFor == title;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 140.0 : (screenWidth - 80) / 3;

    return GestureDetector(
      onTap: () => setState(() => lookingFor = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: cardWidth,
        height: cardWidth * 1.1,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4ECFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF7E57C2) : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: screenWidth > 600 ? 42 : 32)),
            SizedBox(height: screenWidth > 600 ? 12 : 8),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth > 600 ? 16 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeName = widget.name.isNotEmpty ? widget.name : "there";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF6EEFF), Color(0xffFDEBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Match Preferences",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    stepDots(),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 320,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i) => setState(() => currentPage = i),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Looking for",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF7E57C2),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  optionCard("👨", "Male"),
                                  optionCard("👩", "Female"),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Age Range",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF7E57C2),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: RangeSlider(
                                  values: ageRange,
                                  min: 18,
                                  max: 60,
                                  activeColor: const Color(0xFF7E57C2),
                                  onChanged: (v) => setState(() => ageRange = v),
                                ),
                              ),
                              Text(
                                "${ageRange.start.toInt()} - ${ageRange.end.toInt()} years",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ideal Date Expectation",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF7E57C2),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: dateExpectationCtrl,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: "Describe your ideal date...",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 80,
                                color: Color(0xFF7E57C2),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "All Set, $safeName!",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Ready to find your match",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        if (currentPage > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: backPage,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text("Back"),
                            ),
                          ),
                        if (currentPage > 0) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7E57C2),
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 4,
                            ),
                            onPressed: currentPage == 3 ? finish : nextPage,
                            child: Text(
                              textAlign: TextAlign.center,
                              currentPage == 3 ? "Start Matching" : "Continue",
                              style: const TextStyle(
                                
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

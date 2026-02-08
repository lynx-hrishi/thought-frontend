import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'page_transition.dart';

class MatchPreferencesPage extends StatefulWidget {
  final String name;
  final String bio;

  const MatchPreferencesPage({
    super.key,
    required this.name,
    required this.bio,
  });

  @override
  State<MatchPreferencesPage> createState() => _MatchPreferencesPageState();
}

class _MatchPreferencesPageState extends State<MatchPreferencesPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  String lookingFor = "Female";
  RangeValues ageRange = const RangeValues(20, 30);
  double distance = 20;

  void nextPage() {
    if (currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    }
  }

  void finish() {
    Navigator.pushReplacement(
      context,
      SlidePageRoute(page: const DashboardPage()),
    );
  }

  /// ---------------- STEP DOTS ----------------
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

  /// ---------------- OPTION CARD ----------------
  Widget optionCard(String emoji, String title) {
    final bool selected = lookingFor == title;

    return GestureDetector(
      onTap: () => setState(() => lookingFor = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 150,
        height: 170,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4ECFF) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? const Color(0xFF7E57C2)
                : Colors.grey.shade200,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 42)),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
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
      backgroundColor: const Color(0xFFF7F4FB),
      body: Center(
        child: Container(
          width: 1100,
          height: 640,
          padding: const EdgeInsets.all(36),

          /// -------- LOGIN CARD STYLE --------
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF3ECFA), // lavender
                Color(0xFFFDEFF4), // soft pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 40,
                offset: const Offset(0, 22),
              ),
            ],
          ),

          child: Row(
            children: [
              /// ---------------- LEFT BRANDING ----------------
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Build your\nprofile vibe ✨",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "A few quick picks so your\nmatches feel just right.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ---------------- RIGHT CONTENT ----------------
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    stepDots(),
                    const SizedBox(height: 28),

                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i) =>
                            setState(() => currentPage = i),
                        children: [
                          /// -------- STEP 1 --------
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Who are you feeling today? 💜",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 44),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  optionCard("👨", "Male"),
                                  optionCard("👩", "Female"),
                                  optionCard("🌈", "Everyone"),
                                ],
                              ),
                            ],
                          ),

                          /// -------- STEP 2 --------
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Preferred age range 🎂",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 36),
                              RangeSlider(
                                values: ageRange,
                                min: 18,
                                max: 60,
                                activeColor:
                                const Color(0xFF7E57C2),
                                onChanged: (v) =>
                                    setState(() => ageRange = v),
                              ),
                              Text(
                                "${ageRange.start.toInt()} – ${ageRange.end.toInt()} years",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),

                          /// -------- STEP 3 --------
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "How far should love travel? 📍",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 36),
                              Slider(
                                value: distance,
                                min: 5,
                                max: 100,
                                divisions: 19,
                                activeColor:
                                const Color(0xFF7E57C2),
                                label: "${distance.toInt()} km",
                                onChanged: (v) =>
                                    setState(() => distance = v),
                              ),
                              Text(
                                "${distance.toInt()} km",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),

                          /// -------- STEP 4 --------
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You’re all set, $safeName 💕",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Your vibe is locked in. Let’s begin.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// -------- LOGIN STYLE BUTTON --------
                    SizedBox(
                      width: 420,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF7E57C2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        onPressed:
                        currentPage == 3 ? finish : nextPage,
                        child: Text(
                          currentPage == 3
                              ? "Finish Setup"
                              : "Continue",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

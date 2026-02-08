import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FB),
      body: Center(
        child: Container(
          width: 1200,
          height: 700,
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF3ECFA),
                Color(0xFFFDEFF4),
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
              /// ---------------- LEFT PANEL ----------------
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Welcome back 👋",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Your vibe is glowing today.\nLet’s make meaningful connections.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      infoTile("💌 Matches", "12 new people"),
                      infoTile("🔥 Streak", "5 days active"),
                      infoTile("🧠 Mood", "Calm & Thoughtful"),
                    ],
                  ),
                ),
              ),

              /// ---------------- RIGHT PANEL ----------------
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        dashboardCard("📝", "Journal", "Write today’s thoughts"),
                        dashboardCard("💜", "Find Match", "Explore connections"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        dashboardCard("💬", "Chat", "Conversations waiting"),
                        dashboardCard("👤", "Profile", "Edit your vibe"),
                      ],
                    ),
                    const SizedBox(height: 28),

                    /// Recent Activity
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recent Activity",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            activityTile("You matched with Aanya 💜"),
                            activityTile("You wrote a journal entry 📝"),
                            activityTile("3 new messages 💬"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- INFO TILE ----------------
  Widget infoTile(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// ---------------- DASHBOARD CARD ----------------
  Widget dashboardCard(String emoji, String title, String subtitle) {
    return Container(
      width: 320,
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- ACTIVITY TILE ----------------
  Widget activityTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "• $text",
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  /// ---------------- CARD DECORATION ----------------
  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

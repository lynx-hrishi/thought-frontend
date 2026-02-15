// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';

// import 'theme.dart';
// import 'match_preferences_page.dart';
// import 'page_transition.dart';

// class PersonalDetailsPage extends StatefulWidget {
//   const PersonalDetailsPage({super.key});

//   @override
//   State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
// }

// class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
//   int step = 0;
//   final int totalSteps = 8;

//   final nameCtrl = TextEditingController();
//   final dobCtrl = TextEditingController();
//   final otherSundayCtrl = TextEditingController();

//   String gender = "Female";
//   String status = "";
//   String zodiac = "";
//   String emojiVibe = "";

//   List<String> sundayVibes = [];

//   int age = 0;
//   File? avatar;
//   File? postImage;

//   // ---------------- ZODIAC AUTO DETECT ----------------
//   String detectZodiac(DateTime dob) {
//     final d = dob.day;
//     final m = dob.month;

//     if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return "♈ Aries";
//     if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return "♉ Taurus";
//     if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return "♊ Gemini";
//     if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return "♋ Cancer";
//     if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return "♌ Leo";
//     if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return "♍ Virgo";
//     if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return "♎ Libra";
//     if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return "♏ Scorpio";
//     if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return "♐ Sagittarius";
//     if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return "♑ Capricorn";
//     if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return "♒ Aquarius";
//     return "♓ Pisces";
//   }

//   // ---------------- STEP VALIDATION ----------------
//   bool get isStepValid {
//     switch (step) {
//       case 0:
//         return avatar != null;
//       case 1:
//         return postImage != null;
//       case 2:
//         return nameCtrl.text.trim().isNotEmpty;
//       case 3:
//         return age >= 18;
//       case 4:
//         return status.isNotEmpty;
//       case 5:
//         return sundayVibes.isNotEmpty ||
//             otherSundayCtrl.text.trim().isNotEmpty;
//       case 6:
//         return emojiVibe.isNotEmpty;
//       default:
//         return true;
//     }
//   }

//   // ---------------- SUMMARY ----------------
//   String get personalitySummary {
//     final allSunday = [
//       ...sundayVibes,
//       if (otherSundayCtrl.text.isNotEmpty) otherSundayCtrl.text
//     ].join(", ");

//     return """
// ✨ ${nameCtrl.text} is a $age year old $gender who is currently $status.

// Zodiac Sign: $zodiac 🌙  
// Ideal Sundays include $allSunday  
// Overall vibe: $emojiVibe  

// A thoughtful soul who values meaningful conversations 💜
// """;
//   }

//   // ---------------- NAVIGATION ----------------
//   void next() {
//     if (!isStepValid) return;

//     if (step < totalSteps - 1) {
//       setState(() => step++);
//     } else {
//       Navigator.push(
//         context,
//         SlidePageRoute(
//           page: MatchPreferencesPage(
//             name: nameCtrl.text,
//             bio: personalitySummary,
//           ),
//         ),
//       );
//     }
//   }

//   void back() {
//     if (step > 0) setState(() => step--);
//   }

//   // ---------------- HELPERS ----------------
//   void calculateAge(DateTime picked) {
//     final now = DateTime.now();
//     age = now.year - picked.year;
//     if (now.month < picked.month ||
//         (now.month == picked.month && now.day < picked.day)) {
//       age--;
//     }
//     zodiac = detectZodiac(picked);
//   }

//   Future<void> pickAvatar() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) setState(() => avatar = File(picked.path));
//   }

//   Future<void> pickPostImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) setState(() => postImage = File(picked.path));
//   }

//   // ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width > 800;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xffF6EEFF), Color(0xffFDEBFF)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24),
//                 child: _glassCard(
//                   Row(
//                     children: [
//                       if (isWide)
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(24),
//                             child: Text(
//                               "Build your\nprofile vibe 💫",
//                               style: GoogleFonts.playfairDisplay(
//                                 fontSize: 42,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             _progressDots(),
//                             const SizedBox(height: 30),
//                             IndexedStack(
//                               index: step,
//                               children: [
//                                 _avatarStep(),
//                                 _postImageStep(),
//                                 _nameGenderStep(),
//                                 _dobStep(),
//                                 _statusStep(),
//                                 _sundayStep(),
//                                 _emojiStep(),
//                                 _summaryStep(),
//                               ],
//                             ),
//                             const SizedBox(height: 30),
//                             Row(
//                               children: [
//                                 if (step > 0)
//                                   Expanded(
//                                     child: OutlinedButton(
//                                       onPressed: back,
//                                       child: const Text("Back"),
//                                     ),
//                                   ),
//                                 if (step > 0) const SizedBox(width: 16),
//                                 Expanded(
//                                   child: _gradientButton(
//                                     "Continue",
//                                     isStepValid ? next : null,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------- STEPS ----------------
//   Widget _avatarStep() => _stepWrapper(
//     "🖼️ Add a profile picture",
//     GestureDetector(
//       onTap: pickAvatar,
//       child: CircleAvatar(
//         radius: 55,
//         backgroundImage:
//         avatar != null ? FileImage(avatar!) : null,
//         child: avatar == null
//             ? const Icon(Icons.add_a_photo, size: 40)
//             : null,
//       ),
//     ),
//   );

//   Widget _postImageStep() => _stepWrapper(
//     "🖼️ Add a post image",
//     GestureDetector(
//       onTap: pickPostImage,
//       child: Container(
//         height: 160,
//         width: 160,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.black12),
//           image: postImage != null
//               ? DecorationImage(
//             image: FileImage(postImage!),
//             fit: BoxFit.cover,
//           )
//               : null,
//         ),
//         child: postImage == null
//             ? const Icon(Icons.add_photo_alternate, size: 40)
//             : null,
//       ),
//     ),
//   );

//   Widget _nameGenderStep() => _stepWrapper(
//     "👤 Tell us about you",
//     Column(
//       children: [
//         TextField(
//           controller: nameCtrl,
//           decoration: const InputDecoration(hintText: "Full Name"),
//           onChanged: (_) => setState(() {}),
//         ),
//         const SizedBox(height: 20),
//         DropdownButtonFormField<String>(
//           value: gender,
//           items: ["Female", "Male", "Other"]
//               .map((e) =>
//               DropdownMenuItem(value: e, child: Text(e)))
//               .toList(),
//           onChanged: (v) => setState(() => gender = v!),
//         ),
//       ],
//     ),
//   );

//   Widget _dobStep() => _stepWrapper(
//     "🎂 Your birthday",
//     TextField(
//       controller: dobCtrl,
//       readOnly: true,
//       decoration:
//       const InputDecoration(hintText: "Select Date of Birth"),
//       onTap: () async {
//         final today = DateTime.now();
//         final picked = await showDatePicker(
//           context: context,
//           firstDate: DateTime(1950),
//           lastDate:
//           DateTime(today.year - 18, today.month, today.day),
//           initialDate: DateTime(2000),
//         );
//         if (picked != null) {
//           calculateAge(picked);
//           dobCtrl.text =
//           "${picked.day}/${picked.month}/${picked.year} • $zodiac";
//           setState(() {});
//         }
//       },
//     ),
//   );

//   Widget _statusStep() => _stepWrapper(
//     "📚 What are you doing?",
//     Row(
//       children: [
//         Expanded(child: _choiceTile("Studying")),
//         const SizedBox(width: 16),
//         Expanded(child: _choiceTile("Working")),
//       ],
//     ),
//   );

//   Widget _sundayStep() => _stepWrapper(
//     "☀️ Your ideal Sunday",
//     Column(
//       children: [
//         Wrap(
//           spacing: 10,
//           runSpacing: 12,
//           children: [
//             "🎬 Netflix",
//             "📚 Reading",
//             "🎮 Gaming",
//             "🏞️ Trekking",
//             "🧘 Yoga",
//             "💻 Coding",
//             "🎧 Music",
//             "😴 Doing nothing",
//           ].map(_multiPill).toList(),
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           controller: otherSundayCtrl,
//           decoration:
//           const InputDecoration(hintText: "Others (optional)"),
//           onChanged: (_) => setState(() {}),
//         ),
//       ],
//     ),
//   );

//   Widget _emojiStep() => _stepWrapper(
//     "💫 Your vibe",
//     Wrap(
//       spacing: 20,
//       children: ["😎", "😌", "🤓", "🥰", "🔥", "🌸", "✨"]
//           .map(_emojiChoice)
//           .toList(),
//     ),
//   );

//   Widget _summaryStep() =>
//       _stepWrapper("🧠 Summary", Text(personalitySummary));

//   // ---------------- SMALL WIDGETS ----------------
//   Widget _multiPill(String text) {
//     final selected = sundayVibes.contains(text);
//     return ChoiceChip(
//       label: Text(text),
//       selected: selected,
//       onSelected: (v) {
//         setState(() {
//           v ? sundayVibes.add(text) : sundayVibes.remove(text);
//         });
//       },
//     );
//   }

//   Widget _emojiChoice(String emoji) => GestureDetector(
//     onTap: () => setState(() => emojiVibe = emoji),
//     child: Text(
//       emoji,
//       style: TextStyle(
//           fontSize: emojiVibe == emoji ? 46 : 38),
//     ),
//   );

//   Widget _choiceTile(String text) {
//     final selected = status == text;
//     return GestureDetector(
//       onTap: () => setState(() => status = text),
//       child: Container(
//         height: 60,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xFF7E57C2) : null,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: Colors.black12),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//               color: selected ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _progressDots() => Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: List.generate(
//       totalSteps,
//           (i) => Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         width: step == i ? 16 : 8,
//         height: 8,
//         decoration: BoxDecoration(
//           color: step == i
//               ? const Color(0xFF7E57C2)
//               : Colors.grey,
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     ),
//   );

//   Widget _gradientButton(String text, VoidCallback? onTap) =>
//       GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 52,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: onTap == null
//                 ? Colors.grey.shade400
//                 : const Color(0xFF7E57C2),
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Text(
//             text,
//             style:
//             const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       );

//   Widget _glassCard(Widget child) => ClipRRect(
//     borderRadius: BorderRadius.circular(36),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 1000),
//         padding: const EdgeInsets.symmetric(
//             horizontal: 32, vertical: 40),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.85),
//           borderRadius: BorderRadius.circular(36),
//         ),
//         child: child,
//       ),
//     ),
//   );

//   Widget _stepWrapper(String title, Widget child) => Column(
//     children: [
//       Text(
//         title,
//         style: GoogleFonts.poppins(
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       const SizedBox(height: 30),
//       child,
//     ],
//   );
// }

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'theme.dart';
import 'match_preferences_page.dart';
import 'page_transition.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() =>
      _PersonalDetailsPageState();
}

class _PersonalDetailsPageState
    extends State<PersonalDetailsPage> {
  int step = 0;
  final int totalSteps = 8;

  final nameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final otherSundayCtrl = TextEditingController();

  String gender = "Female";
  String status = "";
  String zodiac = "";
  String emojiVibe = "";

  List<String> sundayVibes = [];

  int age = 0;
  File? avatar;
  File? postImage;

  // ---------------- ZODIAC ----------------
  String detectZodiac(DateTime dob) {
    final d = dob.day;
    final m = dob.month;

    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return "♈ Aries";
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return "♉ Taurus";
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return "♊ Gemini";
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return "♋ Cancer";
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return "♌ Leo";
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return "♍ Virgo";
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return "♎ Libra";
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return "♏ Scorpio";
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return "♐ Sagittarius";
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return "♑ Capricorn";
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return "♒ Aquarius";
    return "♓ Pisces";
  }

  bool get isStepValid {
    switch (step) {
      case 0:
        return avatar != null;
      case 1:
        return postImage != null;
      case 2:
        return nameCtrl.text.trim().isNotEmpty;
      case 3:
        return age >= 18;
      case 4:
        return status.isNotEmpty;
      case 5:
        return sundayVibes.isNotEmpty ||
            otherSundayCtrl.text.trim().isNotEmpty;
      case 6:
        return emojiVibe.isNotEmpty;
      default:
        return true;
    }
  }

  String get personalitySummary {
    final allSunday = [
      ...sundayVibes,
      if (otherSundayCtrl.text.isNotEmpty)
        otherSundayCtrl.text
    ].join(", ");

    return """
✨ ${nameCtrl.text} is a $age year old $gender who is currently $status.

Zodiac Sign: $zodiac 🌙  
Ideal Sundays include $allSunday  
Overall vibe: $emojiVibe  

A thoughtful soul who values meaningful conversations 💜
""";
  }

  void next() {
    if (!isStepValid) return;

    if (step < totalSteps - 1) {
      setState(() => step++);
    } else {
      Navigator.push(
        context,
        SlidePageRoute(
          page: MatchPreferencesPage(
            name: nameCtrl.text,
            bio: personalitySummary,
          ),
        ),
      );
    }
  }

  void back() {
    if (step > 0) setState(() => step--);
  }

  void calculateAge(DateTime picked) {
    final now = DateTime.now();
    age = now.year - picked.year;
    if (now.month < picked.month ||
        (now.month == picked.month &&
            now.day < picked.day)) {
      age--;
    }
    zodiac = detectZodiac(picked);
  }

  Future<void> pickAvatar() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null)
      setState(() => avatar = File(picked.path));
  }

  Future<void> pickPostImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null)
      setState(() => postImage = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffF6EEFF), Color(0xffFDEBFF)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: _glassCard(
                    Column(
                      children: [
                        _progressDots(),
                        const SizedBox(height: 30),
                        IndexedStack(
                          index: step,
                          children: [
                            _avatarStep(),
                            _postImageStep(),
                            _nameGenderStep(),
                            _dobStep(),
                            _statusStep(),
                            _sundayStep(),
                            _emojiStep(),
                            _summaryStep(),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            if (step > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: back,
                                  child:
                                      const Text("Back"),
                                ),
                              ),
                            if (step > 0)
                              const SizedBox(width: 16),
                            Expanded(
                              child: _gradientButton(
                                "Continue",
                                isStepValid ? next : null,
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
        ],
      ),
    );
  }


  // ---------------- STEPS ----------------
  Widget _avatarStep() => _stepWrapper(
    "🖼️ Add a profile picture",
    GestureDetector(
      onTap: pickAvatar,
      child: CircleAvatar(
        radius: 55,
        backgroundImage:
        avatar != null ? FileImage(avatar!) : null,
        child: avatar == null
            ? const Icon(Icons.add_a_photo, size: 40)
            : null,
      ),
    ),
  );

  Widget _postImageStep() => _stepWrapper(
    "🖼️ Add a post image",
    GestureDetector(
      onTap: pickPostImage,
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
          image: postImage != null
              ? DecorationImage(
            image: FileImage(postImage!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: postImage == null
            ? const Icon(Icons.add_photo_alternate, size: 40)
            : null,
      ),
    ),
  );

  Widget _nameGenderStep() => _stepWrapper(
    "👤 Tell us about you",
    Column(
      children: [
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: "Full Name"),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: gender,
          items: ["Female", "Male", "Other"]
              .map((e) =>
              DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => gender = v!),
        ),
      ],
    ),
  );

  Widget _dobStep() => _stepWrapper(
    "🎂 Your birthday",
    TextField(
      controller: dobCtrl,
      readOnly: true,
      decoration:
      const InputDecoration(hintText: "Select Date of Birth"),
      onTap: () async {
        final today = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate:
          DateTime(today.year - 18, today.month, today.day),
          initialDate: DateTime(2000),
        );
        if (picked != null) {
          calculateAge(picked);
          dobCtrl.text =
          "${picked.day}/${picked.month}/${picked.year} • $zodiac";
          setState(() {});
        }
      },
    ),
  );

  Widget _statusStep() => _stepWrapper(
    "📚 What are you doing?",
    Row(
      children: [
        Expanded(child: _choiceTile("Studying")),
        const SizedBox(width: 16),
        Expanded(child: _choiceTile("Working")),
      ],
    ),
  );

  Widget _sundayStep() => _stepWrapper(
    "☀️ Your ideal Sunday",
    Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: [
            "🎬 Netflix",
            "📚 Reading",
            "🎮 Gaming",
            "🏞️ Trekking",
            "🧘 Yoga",
            "💻 Coding",
            "🎧 Music",
            "😴 Doing nothing",
          ].map(_multiPill).toList(),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: otherSundayCtrl,
          decoration:
          const InputDecoration(hintText: "Others (optional)"),
          onChanged: (_) => setState(() {}),
        ),
      ],
    ),
  );

  Widget _emojiStep() => _stepWrapper(
    "💫 Your vibe",
    Wrap(
      spacing: 20,
      children: ["😎", "😌", "🤓", "🥰", "🔥", "🌸", "✨"]
          .map(_emojiChoice)
          .toList(),
    ),
  );

  Widget _summaryStep() =>
      _stepWrapper("🧠 Summary", Text(personalitySummary));

  // ---------------- SMALL WIDGETS ----------------
  Widget _multiPill(String text) {
    final selected = sundayVibes.contains(text);
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      onSelected: (v) {
        setState(() {
          v ? sundayVibes.add(text) : sundayVibes.remove(text);
        });
      },
    );
  }

  Widget _emojiChoice(String emoji) => GestureDetector(
    onTap: () => setState(() => emojiVibe = emoji),
    child: Text(
      emoji,
      style: TextStyle(
          fontSize: emojiVibe == emoji ? 46 : 38),
    ),
  );

  Widget _choiceTile(String text) {
    final selected = status == text;
    return GestureDetector(
      onTap: () => setState(() => status = text),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7E57C2) : null,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _progressDots() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      totalSteps,
          (i) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: step == i ? 16 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: step == i
              ? const Color(0xFF7E57C2)
              : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  Widget _gradientButton(String text, VoidCallback? onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: onTap == null
                ? Colors.grey.shade400
                : const Color(0xFF7E57C2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            style:
            const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  Widget _glassCard(Widget child) => ClipRRect(
    borderRadius: BorderRadius.circular(36),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(36),
        ),
        child: child,
      ),
    ),
  );

  Widget _stepWrapper(String title, Widget child) => Column(
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 30),
      child,
    ],
  );
}

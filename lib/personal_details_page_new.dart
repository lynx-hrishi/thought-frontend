import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'match_preferences_page_new.dart';
import 'page_transition.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  int step = 0;
  final int totalSteps = 6;

  final nameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final professionCtrl = TextEditingController();

  String gender = "Female";
  String status = "";
  String zodiac = "";
  DateTime? selectedDate;
  int age = 0;
  File? avatar;
  List<File> postImages = [];
  List<String> interests = [];

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
        return nameCtrl.text.trim().isNotEmpty && gender.isNotEmpty;
      case 1:
        return age >= 18;
      case 2:
        return status.isNotEmpty && professionCtrl.text.trim().isNotEmpty;
      case 3:
        return avatar != null;
      case 4:
        return postImages.isNotEmpty;
      case 5:
        return interests.isNotEmpty;
      default:
        return true;
    }
  }

  String get profileSummary {
    return """
${nameCtrl.text}, $age • $zodiac
$gender • $status

Profession: ${professionCtrl.text}
Interests: ${interests.join(", ")}

Looking for meaningful connections 💜
""";
  }

  void next() {
    if (!isStepValid) return;
    if (step < totalSteps - 1) {
      setState(() => step++);
    } else {
      final formattedDob = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
      Navigator.push(
        context,
        SlidePageRoute(
          page: MatchPreferencesPage(
            name: nameCtrl.text,
            bio: profileSummary,
            gender: gender,
            dateOfBirth: formattedDob,
            zodiacSign: zodiac,
            profession: professionCtrl.text,
            interests: interests,
            profileImage: avatar!,
            postImages: postImages,
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
        (now.month == picked.month && now.day < picked.day)) {
      age--;
    }
    zodiac = detectZodiac(picked);
    selectedDate = picked;
  }

  Future<void> pickAvatar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => avatar = File(picked.path));
  }

  Future<void> pickPostImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => postImages.add(File(picked.path)));
    }
  }

  void removePostImage(int index) {
    setState(() => postImages.removeAt(index));
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    dobCtrl.dispose();
    professionCtrl.dispose();
    super.dispose();
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _glassCard(
                    Column(
                      children: [
                        Text(
                          "Complete Your Profile",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _progressDots(),
                        const SizedBox(height: 30),
                        IndexedStack(
                          index: step,
                          children: [
                            _nameGenderStep(),
                            _dobStep(),
                            _professionStep(),
                            _avatarStep(),
                            _postImageStep(),
                            _interestsStep(),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            if (step > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: back,
                                  child: const Text("Back"),
                                ),
                              ),
                            if (step > 0) const SizedBox(width: 16),
                            Expanded(
                              child: _gradientButton(
                                step == totalSteps - 1 ? "Finish" : "Continue",
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

  Widget _nameGenderStep() => _stepWrapper(
        "Basic Information",
        Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Full Name",
                hintText: "Enter your full name",
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: const InputDecoration(labelText: "Gender"),
              items: ["Female", "Male", "Other"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => gender = v!),
            ),
          ],
        ),
      );

  Widget _dobStep() => _stepWrapper(
        "Date of Birth",
        TextField(
          controller: dobCtrl,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Birthday",
            hintText: "Select your date of birth",
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            final today = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: DateTime(today.year - 18, today.month, today.day),
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

  Widget _professionStep() => _stepWrapper(
        "Professional Details",
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _choiceTile("Studying")),
                const SizedBox(width: 16),
                Expanded(child: _choiceTile("Working")),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: professionCtrl,
              decoration: InputDecoration(
                labelText: status == "Studying" ? "Field of Study" : "Job Title",
                hintText: status == "Studying"
                    ? "e.g., Computer Science"
                    : "e.g., Software Engineer",
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      );

  Widget _avatarStep() => _stepWrapper(
        "Profile Picture",
        Center(
          child: GestureDetector(
            onTap: pickAvatar,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7E57C2), width: 3),
                image: avatar != null
                    ? DecorationImage(image: FileImage(avatar!), fit: BoxFit.cover)
                    : null,
              ),
              child: avatar == null
                  ? const Icon(Icons.add_a_photo, size: 40, color: Color(0xFF7E57C2))
                  : null,
            ),
          ),
        ),
      );

  Widget _postImageStep() => _stepWrapper(
        "Add Photos",
        Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ...postImages.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(entry.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => removePostImage(entry.key),
                        ),
                      ),
                    ],
                  );
                }),
                if (postImages.length < 5)
                  GestureDetector(
                    onTap: pickPostImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF7E57C2), width: 2),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 30, color: Color(0xFF7E57C2)),
                          SizedBox(height: 4),
                          Text("Add", style: TextStyle(color: Color(0xFF7E57C2), fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Add up to 5 photos",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      );

  Widget _interestsStep() => _stepWrapper(
        "Your Interests",
        Wrap(
          spacing: 10,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            "🎬 Movies",
            "📚 Reading",
            "🎮 Gaming",
            "🏞️ Travel",
            "🧘 Fitness",
            "💻 Technology",
            "🎧 Music",
            "🍳 Cooking",
            "🎨 Art",
            "⚽ Sports",
          ].map(_interestChip).toList(),
        ),
      );

  Widget _interestChip(String text) {
    final selected = interests.contains(text);
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      selectedColor: const Color(0xFF7E57C2),
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      onSelected: (v) {
        setState(() {
          v ? interests.add(text) : interests.remove(text);
        });
      },
    );
  }

  Widget _choiceTile(String text) {
    final selected = status == text;
    return GestureDetector(
      onTap: () => setState(() => status = text),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7E57C2) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF7E57C2) : Colors.black12,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
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
              color: step == i ? const Color(0xFF7E57C2) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget _gradientButton(String text, VoidCallback? onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: onTap == null ? Colors.grey.shade400 : const Color(0xFF7E57C2),
            borderRadius: BorderRadius.circular(18),
            boxShadow: onTap != null
                ? [
                    BoxShadow(
                      color: const Color(0xFF7E57C2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _glassCard(Widget child) => ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
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
            child: child,
          ),
        ),
      );

  Widget _stepWrapper(String title, Widget child) => Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7E57C2),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          child,
        ],
      );
}

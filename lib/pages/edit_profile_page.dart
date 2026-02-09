import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../http_service.dart';
import '../models/user_model.dart';
import '../theme.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController professionCtrl;
  late TextEditingController partnerPrefCtrl;
  late String gender;
  List<String> selectedInterests = [];
  bool isLoading = false;

  final List<String> availableInterests = [
    'Reading', 'Travel', 'Music', 'Movies', 'Sports', 'Cooking',
    'Photography', 'Gaming', 'Art', 'Fitness', 'Dancing', 'Writing'
  ];

  @override
  void initState() {
    super.initState();
    professionCtrl = TextEditingController(text: widget.user.profession);
    partnerPrefCtrl = TextEditingController(text: widget.user.partnerPreference ?? '');
    gender = _capitalizeGender(widget.user.gender);
    selectedInterests = List.from(widget.user.interests);
  }

  String _capitalizeGender(String gender) {
    if (gender.isEmpty) return 'Male';
    return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
  }

  @override
  void dispose() {
    professionCtrl.dispose();
    partnerPrefCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    try {
      await HttpService().updateProfile(
        gender: gender,
        profession: professionCtrl.text,
        interests: selectedInterests,
        partnerPreference: partnerPrefCtrl.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name (Non-editable)
            Text(
              'Name',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: widget.user.name),
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Date of Birth (Non-editable)
            Text(
              'Date of Birth',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: widget.user.dateOfBirth),
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Zodiac Sign (Non-editable)
            Text(
              'Zodiac Sign',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: widget.user.zodiacSign),
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Gender (Editable)
            Text(
              'Gender',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: gender,
              items: ['Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => gender = v!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Profession (Editable)
            Text(
              'Profession',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: professionCtrl,
              decoration: const InputDecoration(
                hintText: 'Enter your profession',
              ),
            ),
            const SizedBox(height: 20),

            // Interests (Editable)
            Text(
              'Interests',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableInterests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return ChoiceChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                  selectedColor: AppTheme.pink.withOpacity(0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.pink : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Partner Preference (Editable)
            Text(
              'About Me / Partner Preference',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: partnerPrefCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell us about yourself or your ideal partner...',
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

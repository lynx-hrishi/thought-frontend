import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../http_service.dart';
import '../models/user_model.dart';
import '../theme.dart';
import '../widgets/dio_image.dart';

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
  late String initialGender;
  late String initialProfession;
  late String initialPartnerPref;
  late List<String> initialInterests;
  List<String> selectedInterests = [];
  bool isLoading = false;
  File? newProfileImage;
  List<File> newPostImages = [];

  final List<String> availableInterests = [
    'Reading', 'Travel', 'Music', 'Movies', 'Sports', 'Cooking',
    'Photography', 'Gaming', 'Art', 'Fitness', 'Dancing', 'Writing'
  ];

  @override
  void initState() {
    super.initState();
    professionCtrl = TextEditingController(text: widget.user.profession);
    partnerPrefCtrl = TextEditingController(text: widget.user.partnerPreference ?? '');
    gender = widget.user.gender;
    selectedInterests = List.from(widget.user.interests);
    
    initialGender = gender;
    initialProfession = widget.user.profession;
    initialPartnerPref = widget.user.partnerPreference ?? '';
    initialInterests = List.from(widget.user.interests);
  }

  bool get hasChanges {
    return newProfileImage != null ||
        newPostImages.isNotEmpty ||
        gender != initialGender ||
        professionCtrl.text != initialProfession ||
        partnerPrefCtrl.text != initialPartnerPref ||
        !_listsEqual(selectedInterests, initialInterests);
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var item in a) {
      if (!b.contains(item)) return false;
    }
    return true;
  }

  @override
  void dispose() {
    professionCtrl.dispose();
    partnerPrefCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newProfileImage = File(picked.path));
    }
  }

  Future<void> _pickPostImages() async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => newPostImages = picked.map((e) => File(e.path)).toList());
    }
  }

  void _showImageFullScreen(String imageUrl, int imageIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Image(
                image: DioImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    navigator.pop();
                    
                    try {
                      await HttpService().deleteUserPost(imageIndex);
                      setState(() {
                        widget.user.images.removeAt(imageIndex + 1);
                      });
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Image deleted successfully')),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    try {
      await HttpService().updateProfile(
        gender: gender,
        profession: professionCtrl.text,
        interests: selectedInterests,
        partnerPreference: partnerPrefCtrl.text,
        profileImage: newProfileImage,
        postImages: newPostImages.isNotEmpty ? newPostImages : null,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            // Profile Image (Centered)
            Center(
              child: Column(
                children: [
                  Text(
                    'Profile Image',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: newProfileImage != null
                              ? FileImage(newProfileImage!)
                              : DioImage(widget.user.images[0]),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
              items: ['MALE', 'FEMALE', 'OTHER']
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
            const SizedBox(height: 20),

            // Existing Post Images
            if (widget.user.images.length > 1)
              Text(
                'Current Post Images',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            if (widget.user.images.length > 1) const SizedBox(height: 8),
            if (widget.user.images.length > 1)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.user.images.length - 1,
                  itemBuilder: (context, index) {
                    final imageUrl = widget.user.images[index + 1];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _showImageFullScreen(imageUrl, index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: DioImage(imageUrl),
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (widget.user.images.length > 1) const SizedBox(height: 20),

            // Add New Post Images
            Text(
              'Add New Post Images',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickPostImages,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: newPostImages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 40),
                            SizedBox(height: 4),
                            Text('Tap to add images'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newPostImages.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(newPostImages[index], width: 80, fit: BoxFit.cover),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    // Fixed Save Button at Bottom
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (isLoading || !hasChanges) ? null : _updateProfile,
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
    );
  }
}

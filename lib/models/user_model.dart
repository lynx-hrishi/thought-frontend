class UserModel {
  final String id;
  final String email;
  final String name;
  final String gender;
  final String dateOfBirth;
  final String zodiacSign;
  final String profession;
  final List<String> interests;
  final List<String> images;
  final String? partnerPreference;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.zodiacSign,
    required this.profession,
    required this.interests,
    required this.images,
    this.partnerPreference
  });
}

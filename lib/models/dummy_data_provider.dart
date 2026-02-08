import 'user_model.dart';

class DummyDataProvider {
  static List<UserModel> getDummyUsers() {
    return [
      UserModel(
        id: '1',
        email: 'sarah@example.com',
        name: 'Sarah',
        gender: 'Female',
        dateOfBirth: '1998-05-15',
        zodiacSign: 'Taurus',
        profession: 'Graphic Designer',
        interests: ['Art', 'Travel', 'Photography', 'Music'],
        images: [
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        ],
        partnerPreference: "Looking for someone who loves art and deep conversations"
      ),
      UserModel(
        id: '2',
        email: 'emma@example.com',
        name: 'Emma',
        gender: 'Female',
        dateOfBirth: '1999-08-22',
        zodiacSign: 'Virgo',
        profession: 'Software Engineer',
        interests: ['Coding', 'Gaming', 'Reading', 'Hiking'],
        images: [
          'https://images.unsplash.com/photo-1517849845537-1d51a20414de?w=400',
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ],
        partnerPreference: "Seeking a tech-savvy partner who enjoys outdoor adventures"
      ),
      UserModel(
        id: '3',
        email: 'olivia@example.com',
        name: 'Olivia',
        gender: 'Female',
        dateOfBirth: '1997-12-10',
        zodiacSign: 'Sagittarius',
        profession: 'Marketing Manager',
        interests: ['Fashion', 'Yoga', 'Cooking', 'Travel'],
        images: [
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
          'https://images.unsplash.com/photo-1517849845537-1d51a20414de?w=400',
        ],
        partnerPreference: "Want someone who's passionate about life and loves to travel"
      ),
      UserModel(
        id: '4',
        email: 'sophia@example.com',
        name: 'Sophia',
        gender: 'Female',
        dateOfBirth: '2000-03-18',
        zodiacSign: 'Pisces',
        profession: 'Content Creator',
        interests: ['Vlogging', 'Music', 'Art', 'Fitness'],
        images: [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
        ],
        partnerPreference: "Looking for a creative soul who appreciates music and spontaneity"
      ),
      UserModel(
        id: '5',
        email: 'isabella@example.com',
        name: 'Isabella',
        gender: 'Female',
        dateOfBirth: '1996-07-25',
        zodiacSign: 'Leo',
        profession: 'Architect',
        interests: ['Design', 'Travel', 'Wine Tasting', 'Theater'],
        images: [
          'https://images.unsplash.com/photo-1517849845537-1d51a20414de?w=400',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        ],
        partnerPreference: "Seeking someone ambitious with a great sense of humor"
      ),
    ];
  }
}

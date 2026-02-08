import 'dart:io';

import 'package:currency_converter/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class HttpService{
  static final HttpService _instance = HttpService._internal();
  late Dio dio;
  bool _initialized = false;

  factory HttpService() => _instance;

  HttpService._internal();

  Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();

    final cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/.cookies/'),
      ignoreExpires: false
    );

    dio = Dio(
      BaseOptions(
        baseUrl: "https://arranged-communities-pdt-snake.trycloudflare.com",
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json'
        }
      )
    );

    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(
      LogInterceptor(
        // request: true,
        requestUrl: true,
        // requestHeader: true,
        // responseHeader: true
      )
    );

    _initialized = true;
  }

  Future<Response> loginUser({ required String email }) async {
    return dio.post("/api/auth/login", data: {
      "email": email
    });
  }

  Future<Response> otpVerify({ required String email, required int otp }) async {
    return dio.post("/api/auth/verify", data: {
      "email": email,
      "otp": otp
    });
  }
  
  Future<List<UserModel>> getMatchesForUsers({ int page=1, int limit=10 } ) async {
    final Response res = await dio.get("/api/match/matches?page=$page&limit=$limit");
    
    List matches = res.data['data']['matches'];
    List<UserModel> users = [];
    
    for (var user in matches){
      print(user);
      String profileImage = user['profileImageUrl'];
      List postImages = user['postImageUrl'];

      List<String> userImages = [profileImage];
      
      for (var img in postImages){
        userImages.add(img.toString());
      }

      UserModel newUser = UserModel(
        id: user['_id'], 
        email: user['email'], 
        name: user['name'], 
        gender: user['gender'], 
        dateOfBirth: user['dateOfBirth'], 
        zodiacSign: user['zodiacSign'], 
        profession: user['profession'], 
        interests: List<String>.from(user['interests']), 
        images: userImages,
        partnerPreference: user['partnerPreference'],
        age: user['age']
      );

      users.add(newUser);
    }
    return users;
  }

  Future<UserModel> getUserDetails() async {
    final Response res = await dio.get("/api/user/get-user-details");
    
    var user = res.data['data'];
    String profileImage = user['profileImageUrl'];
    List postImages = user['postImageUrl'];

    List<String> userImages = [profileImage];
    
    for (var img in postImages){
      userImages.add(img.toString());
    }

    return UserModel(
      id: user['_id'], 
      email: user['email'], 
      name: user['name'], 
      gender: user['gender'], 
      dateOfBirth: user['dateOfBirth'], 
      zodiacSign: user['zodiacSign'], 
      profession: user['profession'], 
      interests: List<String>.from(user['interests']), 
      images: userImages,
      partnerPreference: user['partnerPreference'],
      age: user['age']
    );
  }

  Future<bool> checkSession() async {
    try {
      await dio.get("/api/user/get-user-details");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(storage: FileStorage('${dir.path}/.cookies/'));
    await cookieJar.deleteAll();
  }

  Future<bool> likeUserService(String toUser) async {
    final Response res = await dio.post("/api/match/like-user", data: {
      "toUser": toUser
    });

    bool hasMatched = res.data['data']['matchStatus'];
    return hasMatched;
  }

  Future<Response> passUserService(String toUser) async {
    return await dio.post("/api/match/pass-user", data: {
      "toUser": toUser
    });
  }

  Future<List> getMatchedUsersService() async {
    final Response res = await dio.get("/api/match/get-matched-users");
    List matchedUsers = res.data['data'];
    return matchedUsers;
  }
}


// class HttpService{
//   // static final String baseUrl = "https://thoughtdrop-backend.vercel.app";
//   static final String baseUrl = "https://8826-2409-40c0-1031-183-e431-6ffc-a3b9-3faf.ngrok-free.app";

//   Future<Map<String, dynamic>> loginUser(String email) async {
//     final Response res = await post(
//       Uri.parse("$baseUrl/api/auth/login"),
//       headers: {
//         'Content-Type': "application/json"
//       },
//       body: jsonEncode({
//         'email': email
//       })
//     );

//     if (res.statusCode == 200){
//       Map<String, dynamic> data = jsonDecode(res.body);
//       return data;
//     }
//     throw "Can't Login";
//     // return;
//   }
// }
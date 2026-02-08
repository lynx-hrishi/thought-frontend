import 'dart:io';

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
        baseUrl: "https://1c8c-2409-40c0-103a-5d67-b1d5-e432-b0de-5971.ngrok-free.app",
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json'
        }
      )
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestUrl: true,
        requestHeader: true,
        responseHeader: true
      )
    );
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
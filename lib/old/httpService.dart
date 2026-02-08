import 'dart:convert';

import 'package:http/http.dart';

class HttpService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/posts";
  final String postNodeUrl = "https://incoming-screenshots-sheer-queensland.trycloudflare.com";
  final String backendUrl = "https://thoughtdrop-backend.vercel.app";
  
  Future<List<dynamic>> getPosts() async {
    final Response res = await get(
      Uri.parse(baseUrl),
      headers: {
        "User-Agent": "Mozilla/5.0",
        "Accept": "application/json",
      }
    );

    if (res.statusCode == 200){
      final List<dynamic> data = json.decode(res.body);
      // print(data);
      return data;
    }
    else {
      print("STATUS CODE: ${res.statusCode}");
      print("BODY: ${res.body}");
      throw Exception("Can't get Posts");
    }
  }

  Future<Map<String, dynamic>> postData () async {
    final Response res = await post(
      Uri.parse(postNodeUrl),
      headers: {
        "Content-Type": "application/json"
      },
      body: json.encode({
        "name": "Hrishikesh",
        "age": 20,
        "gender": "Male"
      })
    );
    final Map<String, dynamic> resData = json.decode(res.body);
    return resData;
  }

  // Future<Map<String, dynamic>> getUserImage() async {
  //   return ;
  // }
}
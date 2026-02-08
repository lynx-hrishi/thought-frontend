import 'package:flutter/material.dart';
import 'package:http/http.dart';
import './httpService.dart';

class ApiCallingPage extends StatefulWidget {
  const ApiCallingPage({super.key});

  @override
  State<ApiCallingPage> createState() => _ApiCallingPageState();
}

class _ApiCallingPageState extends State<ApiCallingPage> {
  HttpService httpService = HttpService();
  List<dynamic> posts = [];
  Map<String, dynamic> dataOfApi = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Calling"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  final dynamic data = await httpService.getPosts();
                  print(data);
                  setState(() {
                    posts = data;
                  });
                }, 
                child: Text("Click Here")
              ),
              
              posts.isNotEmpty ? Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text("${posts[index]['title']}"),
                      subtitle: Text("${posts[index]['body']}"),
                    );
                  }),
              ) : CircularProgressIndicator(),

              TextButton(
                onPressed: () async {
                  try{
                    final Map<String, dynamic> data = await httpService.postData();
                    print(data);
                    setState(() {
                      dataOfApi = data;
                    });
                  }
                  catch(err){
                    setState(() {
                      dataOfApi = { "message": "Error Occured" };
                    });
                  }
                }, 
                child: Text("Post Data")
              ),

              
              dataOfApi.isNotEmpty ? Text("${dataOfApi['message']}") : Text("")
            ],
          ),
        ),
      )
    );
  }
}
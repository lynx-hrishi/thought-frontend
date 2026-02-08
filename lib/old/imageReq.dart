import 'package:flutter/material.dart';

class ImageReqPage extends StatelessWidget {
  const ImageReqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Req Page"),
      ),
      body: Container(
        child: Column(
          children: [
            Image.network("https://alcohol-manufacturer-thesaurus-placement.trycloudflare.com/api/user/image/6984b5cb54d34be92fc9b635/0"),
            Image.network("https://alcohol-manufacturer-thesaurus-placement.trycloudflare.com/api/user/image/6984b5cb54d34be92fc9b635/banner"),
          ],
        ),
      ),
    );
  }
}
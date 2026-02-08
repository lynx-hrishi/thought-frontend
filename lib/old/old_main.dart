import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Text("Hello World", textDirection: TextDirection.rtl);
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.none,
        width: 5.0,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(title: Text("Hello 1"),),
        body: ColoredBox(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hello World",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 26.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  autocorrect: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter the Amount in USD",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.currency_rupee, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: border,
                    enabledBorder: border,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

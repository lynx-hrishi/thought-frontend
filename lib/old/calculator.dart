import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator()
    );
  }
}

TextButton createButton(String text, Function() onPressed){
  return TextButton(
    onPressed: onPressed,
    child: Text(text)
  );
}

class Calculator extends StatelessWidget{
  TextEditingController num1 = TextEditingController();
  TextEditingController num2 = TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: num1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Number 1"
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: num2,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Number 2"
              ),
            ),
            createButton("+", (){ print(int.parse(num1.text) + int.parse(num2.text)); }),
            createButton("-", (){ print(int.parse(num1.text) - int.parse(num2.text)); }),
            createButton("*", (){ print(int.parse(num1.text) * int.parse(num2.text)); }),
            createButton("/", (){ print(int.parse(num1.text) / int.parse(num2.text)); }),
          ],
        ),
      )
    );
  }
  
}
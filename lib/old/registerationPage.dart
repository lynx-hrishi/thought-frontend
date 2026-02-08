import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegisterationPage()
    );
  }
}

TextField createTextField(String label, bool isPassword, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
  );
}

ListTile createRadioButton(String label, String groupValueStr, Function(String?) onChangeFunc){
  return ListTile(
    title: Text(label),
    leading: Radio(
      value: label.toLowerCase(),
      groupValue: groupValueStr,
      onChanged: onChangeFunc,
    ),
  );
}

CheckboxListTile createCheckBox(String label, bool value, Function(bool?) onChanged){
  return CheckboxListTile(
    title: Text(label),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
  );
}

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String gender = "";

  bool python = false;
  bool java = false;
  bool cpp = false;

  String exp = "Begineer";
  List experiences = ["Begineer", "Intermediate", "Expert"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registeration Page"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            createTextField("Enter Name", false, name),
            SizedBox(height: 20,),
            createTextField("Enter Age", false, age),
            SizedBox(height: 20,),
            createTextField("Enter Email", false, email),
            SizedBox(height: 20,),
            createTextField("Enter Password", false, password),
            SizedBox(height: 20,),
            // createRadioButton("Male", gender, 
            //   (value) {
            //     setState(() {
            //       gender = value!;
            //     });
            //   }
            // ),
            // createRadioButton("Female", gender, 
            //   (value) {
            //     setState(() {
            //       gender = value!;
            //     });
            //   }
            // ),
            createCheckBox("Python", python, 
              (bool? value){
                setState(() {
                  python = value!;
                });
              }  
            ),
            createCheckBox("Java", java, 
              (bool? value){
                setState(() {
                  java = value!;
                });
              }  
            ),
            createCheckBox("C++", cpp, 
              (bool? value){
                setState(() {
                  cpp = value!;
                });
              }  
            ),
            DropdownButton(
              value: exp,
              items: experiences.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(), 
              onChanged: (value){
                setState(() {
                  exp = value!;
                });
              }
            ),
            TextButton(
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${name.text}\n${age.text}\n${email.text}\n${password.text}\n${gender}\n${python ? "Python\n": ""}${java ? "Java": ""}${cpp ? "C++\n" : ""}${exp}")
                  )
                );
              }, 
              child: Text("Submit")
            )
          ],
        ),
      )
    );
  }
}
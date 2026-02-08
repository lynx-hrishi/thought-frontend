import 'package:flutter/material.dart';

Widget customTextField(String label, TextEditingController controller, ValueChanged onChangedFunc, bool isPassword){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      label: Text(label),
      border: OutlineInputBorder()
    ),
    obscureText: isPassword,
    onChanged: onChangedFunc,
  );
}
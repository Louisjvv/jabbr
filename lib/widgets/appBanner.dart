import 'package:flutter/material.dart';

Widget mainBar(BuildContext context) {
  return AppBar(
    title: Text('Jabbr'),
  );
}

InputDecoration nameInputField(String name) {
  return InputDecoration(
    hintText: name,
    hintStyle: TextStyle(color: Color(0xffBFBFBF)),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.lightGreen),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffBFBFBF)),
    ),
  );
}

TextStyle inputText() {
  return TextStyle(
    color: Color(0xffBFBFBF),
    fontSize: 18,
  );
}
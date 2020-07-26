import 'package:flutter/material.dart';

Widget mainBar(BuildContext context) {
  return AppBar(
    title: Text('Jabbr'),
  );
}

Widget chatBar(BuildContext context) {
  return AppBar(
    title: Container(
        child: Row(
          children: [
            Text('Chat'),
            Spacer(),
            GestureDetector(
              onTap: () {
                //TODO
              },
              child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  padding: EdgeInsets.all(2),
                  child: Image.asset("assets/images/online.png",
                    height: 40, width: 40,)),
            ),
          ],
        ),
    ),
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
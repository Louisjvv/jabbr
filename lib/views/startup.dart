import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:jabbr/helper/decorations.dart';
import 'package:jabbr/helper/constants.dart';
import 'package:jabbr/helper/widgets.dart';
import 'package:jabbr/services/auth.dart';
import 'package:jabbr/services/database.dart';
import 'package:jabbr/views/chat.dart';

class Startup extends StatefulWidget {
  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController usernameEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool loading = false;

  startUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      await authService.signUpAnonymously().then((result) async {
        if (result != null) {
          Constants.myUid = result.uid;
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(Constants.myUid);

          Constants.myUserName = usernameEditingController.text;
          Map<String, String> userData = {
            'userName': Constants.myUserName,
            'uid': Constants.myUid,
            'status': 'online',
          };

          if (userInfoSnapshot.documents.isEmpty) {
            DocumentReference docRef = await databaseMethods.addNewUserInfo(
                userData);
            Constants.myDocId = docRef.documentID;
          } else {
            Constants.myDocId = userInfoSnapshot.documents[0].documentID;
            databaseMethods.updateUserInfo(Constants.myDocId, userData);
          }

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Chat()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainBar(context),
      body: loading ? Container(
        child: Center(child: CircularProgressIndicator(),),) : Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Spacer(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameEditingController,
                    decoration: nameInputField('Username'),
                    style: inputText(),
                    validator: (val) {
                      return val.isEmpty || val.length < 3 || val.length > 16
                          ? 'Enter a username between 3 and 16 characters'
                          : null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 64.0,),
            GestureDetector(
              onTap: () {
                startUp();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text('Chat', style: TextStyle(
                    color: Color(0xff2E3944),
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                )
                ),
              ),
            ),
            SizedBox(height: 64.0,),
          ],
        ),
      ),
    );
  }
}
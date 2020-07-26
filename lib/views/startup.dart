import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jabbr/helper/constants.dart';
import 'package:jabbr/services/auth.dart';
import 'package:jabbr/services/database.dart';
import 'package:jabbr/views/chat.dart';
import 'package:jabbr/widgets/appBanner.dart';

class Startup extends StatefulWidget {
  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  TextEditingController usernameEditingController = new TextEditingController();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  startUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService.signUpAnonymously().then((result) async {
        if (result != null) {
          Constants.uid = result.uid;
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(Constants.uid);

          Constants.myName = usernameEditingController.text;
          Map<String, String> userData = {
            'userName' : Constants.myName,
            'uid' : Constants.uid,
            'status' : 'online',
          };

          if(userInfoSnapshot.documents.isEmpty) {
            DocumentReference docRef = await databaseMethods.addUserInfo(userData);
            Constants.docId = docRef.documentID;
          } else {
            Constants.docId = userInfoSnapshot.documents[0].documentID;
            databaseMethods.updateUserInfo(Constants.docId, userData);
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
      body: isLoading ? Container(
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
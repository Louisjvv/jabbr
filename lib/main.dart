// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:jabbr/views/chat.dart';
import 'package:jabbr/views/startup.dart';

import 'helper/helperfunctions.dart';

void main() => runApp(JabbrMain());

class JabbrMain extends StatefulWidget {
  @override
  _JabbrMainState createState() => _JabbrMainState();
}

class _JabbrMainState extends State<JabbrMain> {

//  bool userIsLoggedIn;
//
//  @override
//  void initState() {
//    getLoggedInState();
//    super.initState();
//  }
//
//  getLoggedInState() async {
//    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
//      setState(() {
//        userIsLoggedIn  = value;
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jabbr - Chat securely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff2e3944),
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//        home: userIsLoggedIn != null ?  userIsLoggedIn ? Chat() : Startup()
//            : Container(
//            child: Center(
      home: Startup(),
    );
//        )
//    );
  }
}
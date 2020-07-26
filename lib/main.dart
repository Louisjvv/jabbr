// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:jabbr/services/database.dart';
import 'package:jabbr/views/startup.dart';
import 'helper/constants.dart';

void main() => runApp(JabbrMain());

class JabbrMain extends StatefulWidget {
  @override
  _JabbrMainState createState() => _JabbrMainState();
}

class _JabbrMainState extends State<JabbrMain> with WidgetsBindingObserver{
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      databaseMethods.updateStatus(Constants.docId, 'online');
    }
    else {
      databaseMethods.updateStatus(Constants.docId, 'offline');
    }
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jabbr - Chat securely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff2e3944),
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        home: Startup()
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:jabbr/helper/constants.dart';
import 'package:jabbr/services/database.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> chats;
  Stream<QuerySnapshot> users;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            padding: EdgeInsets.only(bottom: 180.0),
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sentByMe: Constants.myUserName == snapshot.data.documents[index].data["sentBy"],
                sentBy: snapshot.data.documents[index].data["sentBy"],
              );
            }) : Container();
      },
    );
  }

  Widget onlineUsers() {
    return StreamBuilder(
      stream: users,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return snapshot.data.documents[index].data["status"] == "online" ? UserNameTile(
                userName: snapshot.data.documents[index].data["userName"],
              ) : Container();
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sentBy": Constants.myUserName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats().then((val) {
      setState(() {
        chats = val;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 1,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    });
    DatabaseMethods().getOnlineUsers().then((val) {
      setState(() {
        users = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Chat"),
          leading: IconButton(
              icon: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(40)),
                  padding: EdgeInsets.all(2),
                  child: Image.asset("assets/images/online.png",
                    height: 40,
                    width: 40)),
              onPressed: () => _scaffoldKey.currentState.openDrawer())),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SizedBox(height: 16.0),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Type a message",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16),
                              border: InputBorder.none),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        drawer: new Drawer(
          child: Container(
            color: Color(0xff2E3944),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
              Container(
                height: 100.0,
                child: DrawerHeader(
                  child: Text('Online', style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen))),
                Container(
                  child: Stack(
                    children: [
                      onlineUsers()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

}

class UserNameTile extends StatelessWidget {
  final String userName;

  UserNameTile({@required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(23)),
            color: Color(0xff007EF4)),
          child: Column (
              children: [
                Text(userName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.bold)),
              ]
          ),
        )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sentByMe;
  final String sentBy;

  MessageTile({
    @required this.message,
    @required this.sentByMe,
    @required this.sentBy
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sentByMe ? 0 : 24,
          right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sentByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            color: sentByMe ? const Color(0xff007EF4) : const Color(0xffBFBFBF),
            ),
        child: Column (
            children: [
              Text(sentBy,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
              Text(message,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: sentByMe? Colors.white : Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
            ]
        ),
      )
    );
  }
}

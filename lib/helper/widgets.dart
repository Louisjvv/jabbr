import 'package:flutter/material.dart';

Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
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

Widget mainBar(BuildContext context) {
  return AppBar(
    title: Text('Jabbr'),
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
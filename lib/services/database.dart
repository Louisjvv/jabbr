import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<DocumentReference> addUserInfo(userData) async {
    return await Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateUserInfo(docId, userData) async {
    Firestore.instance.document('users/$docId')
        .updateData(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addMessage(chatMessageData) async {
    Firestore.instance.collection("chat")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getChats() async{
    return Firestore.instance
        .collection("chat")
        .orderBy("time")
        .snapshots();
  }

  getOnlineUsers() async{
    return Firestore.instance
        .collection("users")
        .snapshots();
  }

  getUserInfo(uid) async {
    return Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  updateStatus(docId, status) async {
    print(docId);
    Firestore.instance.document("users/$docId")
        .updateData({"status": status})
        .catchError((e) {
      print(e.toString());
    });
  }
}
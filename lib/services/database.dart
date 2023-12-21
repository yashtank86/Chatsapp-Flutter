
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("Users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("Users")
        .where('name', isEqualTo: searchField)
        .getDocuments();
  }


  uploadUserInFo(userMap) {
    Firestore.instance.collection("Users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
    .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("Users", arrayContains: userName)
        .snapshots();
  }

}

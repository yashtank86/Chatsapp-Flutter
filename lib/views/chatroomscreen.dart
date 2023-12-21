import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: (){
                    HapticFeedback.heavyImpact();
                    showMenu(
                      items: <PopupMenuEntry>[
                        PopupMenuItem(
                          height: 30,
                          value: index,
                          child: GestureDetector (
                            onTap: () async {
                              await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                await myTransaction.delete(snapshot.data.documents[index].reference);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.delete),
                                  Text("Delete"),
                                ],),
                            ),
                          ),)],
                      context: context,
                      position:  new RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
                    );
                  },
                  child: ChatRoomTile(
                      snapshot.data.documents[index].data["chatroomId"]
                      .toString().replaceAll("_","")
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.documents[index].data["chatroomId"]
                  ),
                );
              }) : Container();
        });
  }

  @override
  void initState() {
    getUserInFO();
    super.initState();
  }

  getUserInFO() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.myName),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text("Logout:", style: TextStyle(
                      fontSize: 17
                    ),),
                    SizedBox(width: 5,),
                    Icon(Icons.exit_to_app),
                  ],
                )),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen(Constants.myName)));
        },
        child: Icon(Icons.message),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId, userName)
        ));
      },
      child: Container(
        color: Color(0xFFF3F3F3),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(40)),
              child: Text(
                "${userName.substring(0, 1)}".toUpperCase(), style: mediumTextStyle(),
              ),
            ),
            SizedBox(width: 8,),
            Text(userName, style: simpleTsStyle(),),
          ],
        ),
      ),
    );
  }
}

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  final String userName;
  ConversationScreen(this.chatRoomId, this.userName);


  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTEC = new TextEditingController();
  Stream chatMessageStream;


  Widget ChatMessageList(){
      return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
              return GestureDetector(
                onLongPress: (){
                  HapticFeedback.heavyImpact();
                  showMenu(
                  items: <PopupMenuEntry>[
                  PopupMenuItem(
                    height: 30,
                    value: index,
                    child: GestureDetector(
                      onTap: ()  {
                         Firestore.instance.runTransaction((Transaction myTransaction) async {
                          await myTransaction.delete(snapshot.data.documents[index].reference);
                        });
                      },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 2),
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
                child: MessageTile(snapshot.data.documents[index].data["message"],
                    snapshot.data.documents[index].data["sendBy"] == Constants.myName),
              );
              }) : Container();
        },
      );
  }

  sendMessage(){

    if (messageTEC.text.isNotEmpty) {
      Map<String,dynamic> messageMap = {
        "message" : messageTEC.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTEC.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 65),
                child: ChatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xFFF3F3F3),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTEC,
                          decoration: InputDecoration(
                              hintText: "type message here...",
                              hintStyle: TextStyle(
                                  color: Colors.black54
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                        HapticFeedback.heavyImpact();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF009688),
                                const Color(0xFF009688),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/images/send.png")
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        ),
    );
  }
}

class MessageTile extends StatelessWidget {


  final String message;
  final bool sendByMe;
  MessageTile(this.message, this.sendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: sendByMe ? 0 : 15, right: sendByMe ? 15 : 0),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: MediaQuery.of(context).size.width,
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xFF009688),
                const Color(0xFF009688),
              ]
                : [
                const Color(0xFFEEEEEE),
                const Color(0xFFE0E0E0)
                ],
            ),
          borderRadius: sendByMe ?
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                 topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )

        ),
          child: sendByMe ? Text(message, style: TextStyle(
            fontSize: 16,color: Colors.white
          ),) : Text(message, style: TextStyle(
              fontSize: 16,color: Colors.black87
          ),),
        ),
      );
  }
}


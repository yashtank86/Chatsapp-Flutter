import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {

  final String userName;
  SearchScreen(this.userName);


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

 String _myName;

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTEC = new TextEditingController();
  QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchTEC.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchTEC.text)
          .then((snapshot){
        searchSnapshot = snapshot;
        print("$searchSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget searchList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot.documents.length,
        itemBuilder: (context, index){
          return SearchTile(
            searchSnapshot.documents[index].data["name"],
            searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  /*initiateSearch(){
    databaseMethods.getUserByUsername(searchTEC.text)
    .then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }*/

  createCHatRoomAndStartConversation(String userName){

    List<String> users = [userName, Constants.myName];

      String chatRoomId = getChatRoomId( Constants.myName, userName);

      Map<String, dynamic> chatRoomMap = {
        "Users": users,
        "chatroomId" : chatRoomId
      };
      
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId,userName),
      ));

  }

  Widget SearchTile(String userName, String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTsStyle() ),
              Text(userEmail, style: simpleTsStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              HapticFeedback.heavyImpact();
              createCHatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("message", style: mediumTextStyle(),),
            ),
          ),
        ],
      ),
    );

  }

  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    } else{
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.myName),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFFF3F3F3),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTEC,
                        decoration: InputDecoration(
                          hintText: "search users...",
                          hintStyle: TextStyle(
                            color: Colors.black54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
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
                        child: Image.asset("assets/images/search_white.png")
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}





import 'package:chat_app/helper/helperFunctions.dart';
import 'package:flutter/material.dart';

import 'helper/authenticate.dart';
import 'views/chatroomscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF00695C),
      ),
        home:userIsLoggedIn !=null ? userIsLoggedIn ? ChatRoom() : Authenticate()
      :
      Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}




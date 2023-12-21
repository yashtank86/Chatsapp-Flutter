import 'package:flutter/material.dart';

 Widget appBarMain(BuildContext context) {
   return AppBar(
     backgroundColor: const Color(0xFF00695C),
     title: Image.asset("assets/images/ChatsApp.png", height: 50),
   );
 }

  InputDecoration tsInputDecoration(String hintText){
    return InputDecoration(
         hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.black38,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF00695C),),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color:const Color(0xFF00695C),),
      ),
    );
  }

  TextStyle simpleTsStyle(){
   return TextStyle(
     fontSize: 16,
   );
  }
TextStyle mediumTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
User loggedInUser;
String msgText;

class MessageInput extends StatelessWidget {
  final _messageTextController = TextEditingController();
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("+>>>>line23:" + user.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageTextController,
              onChanged: (value) {
                msgText = value;
              },
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          TextButton(
            onPressed: () async {
              _messageTextController.clear();
              await getCurrentUser();
              print(loggedInUser.email + " + " + msgText);
              _firestore
                  .collection('messages')
                  .add({'sender': loggedInUser.email, 'text': msgText});
              //Implement send functionality.
            },
            child: Text(
              'Send',
              style: kSendButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

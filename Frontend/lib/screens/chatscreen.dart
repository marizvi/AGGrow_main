import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/messages.dart';
import 'package:hackathon_app/Widget/newmessage.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  void _addMessage(String message, bool isUser, String userName) {
    print('inside _add msg: $message is user: $isUser');
    setState(() {
      messages.insert(0, {
        'message': message,
        'isUserMessage': isUser,
        'username': userName,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Messages(messages),
        ),
        NewMessage(_addMessage)
      ],
    );
  }
}

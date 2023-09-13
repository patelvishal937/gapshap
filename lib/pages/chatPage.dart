import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapshap_4/services/chat/chatService.dart';
import 'package:gapshap_4/widgets/chatBubble.dart';
import 'package:gapshap_4/widgets/my_text_field.dart';
import 'package:translator/translator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../services/chat/translation.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserId;
  const ChatPage(
      {super.key, required this.reciverUserEmail, required this.reciverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // conver messege into another language

  String language1 = Translations.languages.first;
  String language2 = Translations.languages.first;

  // tranlate Languge

  String? out;
  GoogleTranslator googleTranslator = GoogleTranslator();
  void trnslate(String text) {
    googleTranslator.translate(language1, to: language2).then((output) {
      setState(() {
        out = output.text;
      });
    });
  }

  // controller
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.reciverUserId, _messageController.text);
      // clear the text editor after sending the message
      _messageController.clear();
    }
  }

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('collection');

  Future<void> deleteData(String chat_rooms) async {
    try {
      await collectionRef.doc(chat_rooms).delete();
      print(collectionRef);
      print('Document with ID $chat_rooms deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        // title: Text(widget.reciverUserEmail).centered(),
        title: Row(
          children: [
            Dropdown(
                onChanged: (String? newValue) {
                  setState(() {
                    language1 = newValue.toString();
                  });
                },
                selectedLanguage: language1),
            const SizedBox(width: 10),
            const Icon(Icons.published_with_changes_sharp),
            const SizedBox(width: 10),
            Dropdown(
                onChanged: (String? newValue) {
                  setState(() {
                    language2 = newValue.toString();
                  });
                },
                selectedLanguage: language2),
          ],
        ).centered(),
      ),
      body: Column(
        children: [
          // message
          Expanded(
            child: _buildMessageList(),
          ),

          // User Input

          _buildMessageInput(),
        ],
      ),
    );
  }

  // build a message list

  Widget _buildMessageList() {
    print("Inside _buildMessageList");
    return StreamBuilder(
      stream: _chatService.getMessage(
          widget.reciverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        // error in retrival of data

        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        // fetch the data

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator().centered();
        }
        // if there is a no message

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print("No Messages");
          return const Text("Let's talk to Eachother").centered();
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buldMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build a messege item

  Widget _buldMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // allign the message to the right if the sender is current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,

      // for deleting the messege
      child: GestureDetector(
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete the messege'),
            content: const Text(''),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => deleteData(collectionRef.toString()),
                child: const Text('Yes'),
              ),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text(data['senderEmailId']).px8(),
            // ChatBubble(message: data['message']),

            FutureBuilder<String>(
              future: _translateMessage(data['message']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: const Text('loading'),
                  );
                } else if (snapshot.hasError) {
                  return Text('Translation Error: ${snapshot.error}');
                } else {
                  return ChatBubble(message: snapshot.data ?? data['message']);
                }
              },
            ),
            // Text(data['day'].toString()).px12(),
            // Text(data['message']),
          ],
        ),
      ),
    );
  }

  // translate langaage
  Future<String> _translateMessage(String message) async {
    if (language1 != language2) {
      final translation = await googleTranslator.translate(message,
          from: language1, to: language2);
      return translation.text;
    }
    return message; // Return the original message if no translation is needed
  }

  // build a messege input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // textfield
        Expanded(
          child: MyTextField(
              controller: _messageController,
              hintText: "Enter the Text",
              obsucureText: false),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 40,
            )),
      ],
    ).p8();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapshap_4/Model/message.dart';
import 'package:intl/intl.dart';

class ChatService extends ChangeNotifier {
  // get instance of firebaseauth and FirebaseFirestore
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND A MESSAGE

  Future<void> sendMessage(String reciverId, String message) async {
    //  get current user info

    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final String hour = DateTime.now().hour.toString();
    final String minute = DateTime.now().minute.toString();
    final DateTime dateTime = DateTime.now();
    String formattedTime = DateFormat.jm().format(dateTime);
    // create a new messege

    Message newmessage = Message(
      senderId: currentUserID,
      senderEmailId: currentUserEmail,
      reciverId: reciverId,
      message: message,
      timestamp: timestamp,
      hour: hour,
      minute: minute,
      day: formattedTime,
    );

    // contruct chat room id from current user id (sorted to ensure uniqueness)

    List<String> ids = [currentUserID, reciverId];
    ids.sort(); //sort the ids (this ensure that chat room id is always the same for any pair of id)

    String chatRoomId = ids.join(
        "_"); //combined the id inot a single string to use As a chatroomId
    // add messege to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(
          newmessage.toMap(),
        );
  }
  // GET MESSAGES

  Stream<QuerySnapshot> getMessage(String userId, String otheUserId) {
    // construct the chatroom id from user ids (sorted to ensure it matches the id when it send the messages)
    List<String> ids = [userId, otheUserId];
    ids.sort();
    String chatRoomID = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

//  DELETE MESSAGE

  Future<void> deleteMessage(String chatRoomID, String messages) async {
    // Get a reference to the message document
    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(messages);

    // Delete the message document
    await messageRef.delete();

    
  }
}

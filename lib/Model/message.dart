import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmailId;
  final String reciverId;
  final String message;
  final Timestamp timestamp;
  final String hour;
  final String minute;
  final String day;

  Message({
    required this.senderId,
    required this.senderEmailId,
    required this.reciverId,
    required this.message,
    required this.timestamp,
    required this.hour,
    required this.minute,
    required this.day,
  });
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmailId': senderEmailId,
      'reciverId': reciverId,
      'message': message,
      'timestamp': timestamp,
      'hour':hour,
      'minute':minute,
      'day':day,
      
    };
  }
}

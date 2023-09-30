import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/enums/message_enum.dart';

class Message {
  final String receiverId;
  final String senderId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  Message({
    required this.receiverId,
    required this.senderId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiverId': this.receiverId,
      'senderId': this.senderId,
      'text': this.text,
      'type': type.type,
      'timeSent': Timestamp.fromDate(this.timeSent),
      'messageId': this.messageId,
      'isSeen': this.isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      receiverId: map['receiverId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: (map['timeSent'] as Timestamp).toDate(),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    );
  }
}

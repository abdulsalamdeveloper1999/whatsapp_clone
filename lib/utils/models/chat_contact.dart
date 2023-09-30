import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final DateTime timeSent;
  final String lastMessage;
  final String contactId;

  ChatContact({
    required this.contactId,
    required this.name,
    required this.profilePic,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'contactId': this.contactId,
      'profilePic': this.profilePic,
      // Convert DateTime to Firestore Timestamp
      'timeSend': Timestamp.fromDate(this.timeSent),
      'lastMessage': this.lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      contactId: map['contactId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      // Convert Firestore Timestamp to DateTime
      timeSent: (map['timeSend'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}

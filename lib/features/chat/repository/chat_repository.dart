import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/repository/common_firebase_repository.dart';
import 'package:whatsapp_ui/utils/components/utils.dart';
import 'package:whatsapp_ui/utils/models/chat_contact.dart';
import 'package:whatsapp_ui/utils/models/message.dart';
import 'package:whatsapp_ui/utils/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({
    required this.firestore,
    required this.firebaseAuth,
  });
  Stream<List<Message>> getChatStream(String receiverId) {
    return firestore
        .collection('usersCollection')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        final message = Message.fromMap(document.data());
        messages.add(message);

        // // Print the message to check if it's a sender or receiver message
        // if (message.senderId == firebaseAuth.currentUser!.uid) {
        //   print('Sender Message: ${message.text}');
        // } else {
        //   print('Receiver Message: ${message.text}');
        // }
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('usersCollection')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('usersCollection')
            .doc(chatContact.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);

        // Convert the Timestamp to DateTime
        // var timeSend = DateFormat.Hm().format(chatContact.timeSend);

        contacts.add(ChatContact(
          contactId: chatContact.contactId,
          name: user.name,
          profilePic: user.profilePic,
          timeSent: chatContact.timeSent, // Use the converted DateTime
          lastMessage: chatContact.lastMessage,
        ));
      }

      return contacts;
    });
  }

  _saveDataToContactSubCollection({
    required UserModel receiverData,
    required UserModel senderData,
    required String text,
    required DateTime timeSend,
    required String receiverUserId,
  }) async {
    ///users -> ->receiver user id => chats -> current user id -> set data
    var receiverChatContact = ChatContact(
      name: senderData.name,
      profilePic: senderData.profilePic,
      timeSent: timeSend,
      lastMessage: text,
      contactId: senderData.uid,
    );

    await firestore
        .collection('usersCollection')
        .doc(receiverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );

    ///users -> current user id => chats -> receiver user id -> set data
    var senderChatContact = ChatContact(
      name: receiverData.name,
      profilePic: receiverData.profilePic,
      timeSent: timeSend,
      lastMessage: text,
      contactId: receiverData.uid,
    );

    await firestore
        .collection('usersCollection')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSend,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      receiverId: receiverUserId,
      senderId: firebaseAuth.currentUser!.uid,
      text: text,
      type: messageType,
      timeSent: timeSend,
      messageId: messageId,
      isSeen: false,
    );

    ///users -> current user id => chats -> receiver user id -> set data
    await firestore
        .collection('usersCollection')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    ///users -> ->receiver user id => chats -> current user id -> set data
    await firestore
        .collection('usersCollection')
        .doc(receiverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();

      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('usersCollection').doc(receiverId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = Uuid().v1();

      _saveDataToContactSubCollection(
        receiverData: receiverUserData,
        senderData: senderUser,
        text: text,
        timeSend: timeSent,
        receiverUserId: receiverId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverId,
        text: text,
        timeSend: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      log(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String photoUrl =
          await ref.read(commonFirebaseRepositoryProvider).storeFileToStorage(
                ref:
                    'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
                file: file,
              );

      UserModel receiverUserData;
      var userDataMap = await firestore
          .collection('usersCollection')
          .doc(receiverUserId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactSubCollection(
        receiverData: receiverUserData,
        senderData: senderUserData,
        text: contactMsg,
        timeSend: timeSent,
        receiverUserId: receiverUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: photoUrl,
        timeSend: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

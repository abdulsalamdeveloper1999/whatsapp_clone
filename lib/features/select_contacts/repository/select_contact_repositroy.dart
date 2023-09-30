import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_ui/utils/components/utils.dart';
import 'package:whatsapp_ui/utils/models/user_model.dart';

///Use of Riverpod Here
final selectContactsRepository = Provider(
  (ref) => SelectContactsRepository(firestore: FirebaseFirestore.instance),
);

class SelectContactsRepository {
  final FirebaseFirestore firestore;

  SelectContactsRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      log(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('usersCollection').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var user = UserModel.fromMap(document.data());
        String selectPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        // print(selectedContact.phones[0].number);
        if (selectPhoneNumber == user.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': user.name,
              'uid': user.uid,
            },
          );
        } else if (!isFound) {
          showSnackBar(
            context: context,
            content: 'This number does\'nt exist on this app',
          );
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

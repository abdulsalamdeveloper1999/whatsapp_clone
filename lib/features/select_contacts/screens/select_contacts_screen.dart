import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/utils/components/error_screen.dart';
import 'package:whatsapp_ui/utils/components/loader.dart';
import 'package:whatsapp_ui/utils/components/mytext.dart';

import '../controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/selectContacts-screen';
  const SelectContactScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectContact, BuildContext context) {
    ref.read(selectControllerProvider).selectContact(
          selectContact,
          context,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('Select Contacts'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),

        ///getContactProvider is returning Future function so we can use .when it is basically fuure builder
        body: ref.watch(getContactProvider).when(
              data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (BuildContext context, int index) {
                  final contact = contactList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      onTap: () => selectContact(ref, contact, context),
                      leading: contact.photo == null ? null : CircleAvatar(),
                      title: MyText(
                        text: contact.displayName,
                        size: 18.0,
                      ),
                    ),
                  );
                },
              ),
              error: (error, trace) => ErrorScreen(error: error.toString()),
              loading: () => Loader(),
            ),
      ),
    );
  }
}

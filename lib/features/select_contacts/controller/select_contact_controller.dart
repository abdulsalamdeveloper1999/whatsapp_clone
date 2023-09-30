//
// import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repositroy.dart';
//
// class SelectContactsController{
//
//   final SelectContactsRepository selectContactsRepository;
//
//   SelectContactsController({required this.selectContactsRepository});
//
//
//   void getContacts(){
//     selectContactsRepository.getContacts();
//
//   }
//
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repositroy.dart';

final getContactProvider = FutureProvider((ref) {
  final selectContactRepository =
      ref.watch(selectContactsRepository).getContacts();
  return selectContactRepository;
});

final selectControllerProvider = Provider(
  (ref) {
    final selectControllerRepository = ref.watch(selectContactsRepository);
    return SelectContactController(
      ref: ref,
      selectContactsRepository: selectControllerRepository,
    );
  },
);

class SelectContactController {
  final ProviderRef ref;
  final SelectContactsRepository selectContactsRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactsRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(selectedContact, context);
  }
}

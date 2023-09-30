import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_ui/utils/models/chat_contact.dart';
import 'package:whatsapp_ui/utils/models/message.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverId: receiverId,
            senderUser: value!,
          ),
        );
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required MessageEnum messageEnum,
    required String receiverId,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
          ),
        );
  }
}

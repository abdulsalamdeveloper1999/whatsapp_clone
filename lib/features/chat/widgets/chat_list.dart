import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/utils/models/message.dart';

import '../../../utils/components/loader.dart';
import '../controller/chat_controller.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).getChatStream(widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              final isMyMessage = messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid;

              if (isMyMessage) {
                // Display your own message
                return MyMessageCard(
                  message: messageData.text,
                  date: DateFormat.Hm().format(messageData.timeSent),
                  type: messageData.type,
                );
              } else {
                // Display the other person's message
                return SenderMessageCard(
                  message: messageData.text,
                  date: DateFormat.Hm().format(messageData.timeSent),
                  type: messageData.type,
                );
              }
            },
          );
        });
  }
}

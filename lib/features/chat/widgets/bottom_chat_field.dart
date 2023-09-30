import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/utils/components/utils.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverId;
  const BottomChatField({
    Key? key,
    required this.receiverId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  String isText = '';
  final textController = TextEditingController();
  bool isShowEmojiKeyboard = false;
  FocusNode focusNode = FocusNode();

  var border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(30),
  );

  void sendTextMessage() {
    ref.watch(chatControllerProvider).sendTextMessage(
          context: context,
          text: textController.text.trim(),
          receiverId: widget.receiverId,
        );

    textController.clear();
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiContainer() {
    if (isShowEmojiKeyboard) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          messageEnum: messageEnum,
          receiverId: widget.receiverId,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      // height: size.height * 0.070,
      width: double.maxFinite,
      color: appBarColor,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: toggleEmojiContainer,
                      child: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    focusNode: focusNode,
                    controller: textController,
                    onChanged: (newValue) {
                      setState(() {
                        isText = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        splashRadius: 0.9,
                        splashColor: Colors.transparent,
                        onPressed: selectVideo,
                        icon: Icon(Icons.video_camera_back_outlined),
                      ),
                      filled: true,
                      fillColor: Colors.white12,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: selectImage,
                child: Container(
                  padding: EdgeInsets.only(right: 5, left: 10),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              GestureDetector(
                onTap: sendTextMessage,
                child: Container(
                  padding: EdgeInsets.only(right: 10, left: 5),
                  child: Icon(
                    isText.isNotEmpty ? Icons.send : Icons.mic,
                    size: 26,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          isShowEmojiKeyboard
              ? SizedBox(
                  height: 310,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        textController.text = textController.text + emoji.emoji;
                        isText = textController.text + emoji.emoji;
                      });
                    },
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

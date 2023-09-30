import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';

import '../../../common/enums/message_enum.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  const DisplayTextImageGif({
    required this.message,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: message,
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.height * 0.25,
                  fit: BoxFit.cover,
                  placeholder: (_, loading) {
                    return Padding(
                      padding: const EdgeInsets.all(60),
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              );
  }
}

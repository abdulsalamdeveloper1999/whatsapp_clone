import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController controller;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        controller.setVolume(1);
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            CachedVideoPlayer(controller),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  if (isPlay) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                icon: Icon(isPlay ? Icons.stop_circle : Icons.play_circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

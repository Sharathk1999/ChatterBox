import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/enums/message_enum.dart';
import 'package:chatterbox/features/chat/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

class DisplayImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayImageGIF({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16, color: whiteColor),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(
              builder: (context, setState) {
                
              return IconButton(
                constraints: const BoxConstraints(
                  minWidth: 200,
                      
                ),
                  onPressed: () async{
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      },);
                    }else{
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlaying=true;
                      },);
                    }
                  },
                  icon:  Icon(
                   isPlaying ? Icons.pause_circle: Icons.play_circle_fill_rounded,
                  ),
                );
              }
            )
            : type == MessageEnum.video
                ? VideoPlayerWidget(
                    videoUrl: message,
                  )
                : type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                      )
                    : CachedNetworkImage(
                        imageUrl: message,
                      );
  }
}

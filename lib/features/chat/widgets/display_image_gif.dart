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
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16, color: whiteColor),
          )
        : type == MessageEnum.video
            ? VideoPlayerWidget(videoUrl: message)
            : CachedNetworkImage(imageUrl: message);
  }
}
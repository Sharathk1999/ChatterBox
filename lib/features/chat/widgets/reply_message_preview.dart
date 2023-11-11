import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/providers/message_reply_provider.dart';
import 'package:chatterbox/features/chat/widgets/display_image_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyMessagePreview extends ConsumerWidget {
  const ReplyMessagePreview({super.key});

  void cancelReply(WidgetRef ref){
    // ignore: deprecated_member_use
    ref.watch(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(10),
      decoration:const BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12)
        )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onTap: (){
                  cancelReply(ref);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DisplayImageGIF(message: messageReply.message, type: messageReply.messageEnum),
        ],
      ),
    );
  }
}

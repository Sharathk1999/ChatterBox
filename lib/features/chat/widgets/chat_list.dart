import 'package:chatterbox/common/enums/message_enum.dart';
import 'package:chatterbox/common/providers/message_reply_provider.dart';
import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/features/chat/controller/chat_controller.dart';
import 'package:chatterbox/features/chat/widgets/my_message_card.dart';
import 'package:chatterbox/features/chat/widgets/sender_message_card.dart';
import 'package:chatterbox/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({required this.receiverUserId,super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  void onMessageReply(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ){
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => MessageReply(message, isMe, messageEnum,),);
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<List<MessageModel>>(
      stream: ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) { 
          messageScrollController.jumpTo(messageScrollController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageScrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var sendTime = DateFormat.Hm().format(snapshot.data![index].sendTime);
            // if (!messageData.isSeen && messageData.receiverId == FirebaseAuth.instance.currentUser!.uid) {
            //   ref.read(chatControllerProvider).setChatMessageSeen(context, widget.receiverUserId, messageData.receiverId);
            // }
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: sendTime,
                type: messageData.messageType,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                replyMessageType: messageData.repliedMessageType,
                onLeftSwipe: () => onMessageReply(messageData.text, true, messageData.messageType),
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: sendTime,
              type: messageData.messageType,
                    username: messageData.repliedTo,
                replyMessageType: messageData.repliedMessageType,
                onRightSwipe: () => onMessageReply(messageData.text, false, messageData.messageType),
                repliedText: messageData.repliedMessage,
            );
          },
        );
      }
    );
  }
  }

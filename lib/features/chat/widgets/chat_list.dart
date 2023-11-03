import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/features/chat/controller/chat_controller.dart';
import 'package:chatterbox/models/message.dart';
import 'package:chatterbox/widgets/my_message_card.dart';
import 'package:chatterbox/widgets/sender_message_card.dart';
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
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: sendTime,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: sendTime,
            );
          },
        );
      }
    );
  }
  }

import 'dart:io';

import 'package:chatterbox/common/enums/message_enum.dart';
import 'package:chatterbox/common/providers/message_reply_provider.dart';
import 'package:chatterbox/features/auth/controller/auth_controller.dart';
import 'package:chatterbox/features/chat/repositories/chat_repository.dart';
import 'package:chatterbox/models/chat_contact_model.dart';
import 'package:chatterbox/models/group_model.dart';
import 'package:chatterbox/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContactModel>> chatCOntacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<MessageModel>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<MessageModel>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,),
        );
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              messageEnum: messageEnum,
              ref: ref,
              messageReply: messageReply,
              isGroupChat: isGroupChat,),
        );
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,));
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context, String receiverUserId, String messageId) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}

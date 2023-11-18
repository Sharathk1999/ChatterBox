import 'dart:io';

import 'package:chatterbox/common/enums/message_enum.dart';
import 'package:chatterbox/common/providers/message_reply_provider.dart';
import 'package:chatterbox/common/repository/firebase_common_storage_repo.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/models/chat_contact_model.dart';
import 'package:chatterbox/models/message.dart';
import 'package:chatterbox/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContactModel.fromMap(
          document.data(),
        );
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContactModel(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            sendTime: chatContact.sendTime,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('sendTime')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(
          MessageModel.fromMap(
            document.data(),
          ),
        );
      } 
      return messages;
    });
  }

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime sendTime,
    String receiverUserId,
  ) async {
    //saving receiver message
    var receiverChatContact = ChatContactModel(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      sendTime: sendTime,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );
    //saving sender message
    var senderChatContact = ChatContactModel(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      sendTime: sendTime,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime sendTime,
    required String messageId,
    required String username,
    required receiverUsername,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String receiverUserName,
  
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      messageId: messageId,
      text: text,
      messageType: messageType,
      sendTime: sendTime,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null ? '' : messageReply.isMe ? senderUsername : receiverUserName,
      repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    //message sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    //message receiver
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply, 
  }) async {
    try {
      var sendTime = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        text,
        sendTime,
        receiverUserId,
      );

      _saveMessageToSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        sendTime: sendTime,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUser.name,
        messageReply: messageReply,
        receiverUserName: receiverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      if (context.mounted){
        showSnackBar(context: context, content: e.toString());
        }
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var sendTime = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(firebaseCommonStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
            file,
          );

      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      

      String contactsMessage;

      switch (messageEnum) {
        case MessageEnum.image:
          contactsMessage = '📸 photo';
          break;
        case MessageEnum.video:
          contactsMessage = '🎥 video';
          break;
        case MessageEnum.audio:
          contactsMessage = '🎵 audio';
          break;
        case MessageEnum.gif:
          contactsMessage = 'GIF';
          break;
        default:
          contactsMessage = 'GIF';
      }

      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        contactsMessage,
        sendTime,
        receiverUserId,
      );

      _saveMessageToSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        sendTime: sendTime,
        messageId: messageId,
        username: senderUserData.name,
        receiverUsername: receiverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        receiverUserName: receiverUserData.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      if (context.mounted) {showSnackBar(context: context, content: e.toString());}
    }
  }

   void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var sendTime = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        'GIF',
        sendTime,
        receiverUserId,
      );

      _saveMessageToSubCollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        sendTime: sendTime,
        messageType: MessageEnum.gif,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUser.name,
        messageReply: messageReply,
        receiverUserName: receiverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      if (context.mounted){
        showSnackBar(context: context, content: e.toString());
        }
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  )async{
    try {
      //message sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen':true});

    //message receiver
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen':true});
    } catch (e) {
     if(context.mounted) showSnackBar(context: context, content: e.toString());
    }
  }
}

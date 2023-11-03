

import 'package:chatterbox/common/enums/message_enum.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum messageType;
  final DateTime sendTime;
  final bool isSeen;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.messageType,
    required this.sendTime,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'messageType': messageType.type,
      'sendTime': sendTime.millisecondsSinceEpoch,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      messageType:(map['messageType'] as String).toEnum(),
      sendTime: DateTime.fromMillisecondsSinceEpoch(map['sendTime']),
      isSeen: map['isSeen'] as bool,
    );
  }


}

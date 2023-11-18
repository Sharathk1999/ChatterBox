
import 'package:chatterbox/common/enums/message_enum.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String messageId;
  final String text;
  final MessageEnum messageType;
  final DateTime sendTime;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required  this.messageId,
    required this.text,
    required this.messageType,
    required this.sendTime,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId':messageId,
      'text': text,
      'messageType': messageType.type,
      'sendTime': sendTime.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      messageId: map['messageId'] ?? '',
      text: map['text'] as String,
      messageType: (map['messageType'] as String).toEnum(),
      sendTime: DateTime.fromMillisecondsSinceEpoch(map['sendTime'] as int),
      isSeen: map['isSeen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }



 
}

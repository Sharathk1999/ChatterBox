
class ChatContactModel {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime sendTime;
  final String lastMessage;

  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.sendTime,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'sendTime': sendTime.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
      sendTime: DateTime.fromMillisecondsSinceEpoch(map['sendTime']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }


}

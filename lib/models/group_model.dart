class GroupModel {
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupProfilePic;
  final String senderId;
  final List<String> membersUid;
  GroupModel({
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupProfilePic,
    required this.senderId,
    required this.membersUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupProfilePic': groupProfilePic,
      'senderId': senderId,
      'membersUid': membersUid,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        name: map['name'] ?? "",
        groupId: map['groupId'] ?? "",
        lastMessage: map['lastMessage'] ?? "",
        groupProfilePic: map['groupProfilePic'] ?? "",
        senderId: map['senderId'] ?? "",
        membersUid: List<String>.from(
          (map['membersUid']),
        ));
  }
}

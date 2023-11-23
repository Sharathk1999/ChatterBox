
class StoriesModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String storieId;
  final List<String> whoCanSee;
  StoriesModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.storieId,
    required this.whoCanSee,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'storieId': storieId,
      'whoCanSee': whoCanSee,
    };
  }

  factory StoriesModel.fromMap(Map<String, dynamic> map) {
    return StoriesModel(
      uid: map['uid'] ?? "",
      username: map['username'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      photoUrl: List<String>.from((map['photoUrl'])),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? "",
      storieId: map['storieId'] ?? "",
      whoCanSee: List<String>.from((map['whoCanSee']),
    ));
  }

}

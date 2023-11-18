
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
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: List<String>.from((map['photoUrl'] as List<String>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      profilePic: map['profilePic'] as String,
      storieId: map['storieId'] as String,
      whoCanSee: List<String>.from((map['whoCanSee'] as List<String>),
    ));
  }

}

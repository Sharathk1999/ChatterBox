import 'dart:io';

import 'package:chatterbox/common/repository/firebase_common_storage_repo.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/models/stories_model.dart';
import 'package:chatterbox/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final storieRepositoryProvider = Provider(
  (ref) => StoriesRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StoriesRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StoriesRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStories({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var storieId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(firebaseCommonStorageRepositoryProvider)
          .storeFileToFirebase(
            '/stories/$storieId$uid',
            statusImage,
          );
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        //users who are in the contact list
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> storiesImageUrls = [];

      var storiesSnapshot = await firestore
          .collection('stories')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();
      if (storiesSnapshot.docs.isNotEmpty) {
        StoriesModel storiesModel =
            StoriesModel.fromMap(storiesSnapshot.docs[0].data());
        storiesImageUrls = storiesModel.photoUrl;
        storiesImageUrls.add(imageUrl);
        await firestore
            .collection('stories')
            .doc(storiesSnapshot.docs[0].id)
            .update({
          'photoUrl': storiesImageUrls,
        });
        return;
      } else {
        storiesImageUrls = [imageUrl];
      }

      StoriesModel storiesModel = StoriesModel(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: storiesImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        storieId: storieId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore
          .collection('stories')
          .doc(storieId)
          .set(storiesModel.toMap());
    } catch (e) {
      
        if (context.mounted) showSnackBar(context: context, content: e.toString());
    }
  }
}

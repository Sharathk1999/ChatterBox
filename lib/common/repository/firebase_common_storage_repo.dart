import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseCommonStorageRepositoryProvider = Provider(
  (ref) => FirebaseCommonStorageRepository(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class FirebaseCommonStorageRepository {
  final FirebaseStorage firebaseStorage;
  FirebaseCommonStorageRepository({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
 
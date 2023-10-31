import 'dart:io';

import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/auth/screens/otp_screen.dart';
import 'package:chatterbox/features/auth/screens/user_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (err) {
          throw Exception(err.message);
        },
        codeSent: ((String verificationID, int? resendToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationID);
        }),
        codeAutoRetrievalTimeout: (verificationId) {},
        phoneNumber: phoneNumber,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) {
        return;
      }
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
     await auth.signInWithCredential(credential);
     if(!context.mounted) return;
     Navigator.pushNamedAndRemoveUntil(context, UserInfoScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  })async{
     try {
       String uid = auth.currentUser!.uid;
       String photoUrl = 'https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805_1280.png';
       if (profilePic != null) {
         
       }
     } catch (e) {
       showSnackBar(context: context, content: e.toString());
     }
  }
}

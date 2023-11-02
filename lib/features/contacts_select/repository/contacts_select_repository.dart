import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/models/user_model.dart';
import 'package:chatterbox/screens/mobile_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactSelectRepositoryProvider = Provider(
  (ref) => ContactsSelectRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class ContactsSelectRepository {
  final FirebaseFirestore firestore;

  ContactsSelectRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound =
          false; //this is to display message if that number is not found
       if(!context.mounted) return;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
            if(selectedPhoneNumber == userData.phoneNumber){
              isFound = true;
              Navigator.pushNamed(context, MobileChatScreen.routeName);
            }
            //why else is not used here because if num !found it will keep telling num !found continuously
      }

      if (!isFound) {
        showSnackBar(context: context, content:'This number is not in ChatterBox' );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

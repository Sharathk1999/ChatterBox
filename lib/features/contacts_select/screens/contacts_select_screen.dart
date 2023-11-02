import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/widgets/error_display.dart';
import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/features/contacts_select/controller/contacts_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsSelectScreen extends ConsumerWidget {
  static const String routeName = '/contacts-select-screen';
  const ContactsSelectScreen({super.key});

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context){
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(ref, contact, context),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:5.0,top: 5.0),
                    child: ListTile(
                      title: Text(contact.displayName,style:const TextStyle(color: whiteColor,fontSize: 18),),
                      leading: contact.photo == null ? const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.account_circle,size:38,color: Colors.grey,),
                      ) : CircleAvatar(
                        backgroundImage: MemoryImage(contact.photo!),
                        radius: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
            error: (err, stackTrace) => ErrorDisplayScreen(
              error: err.toString(),
            ),
            loading: () => const LoaderWidget(),
          ),
    );
  }
}

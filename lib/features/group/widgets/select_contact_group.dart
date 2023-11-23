import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/widgets/error_display.dart';
import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/features/contacts_select/controller/contacts_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) {
  return [];
});

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContacts(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContacts.state).update((state) => [...state,contact]);
  }


  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
      data: (contactList) {
        return Expanded(
          child: ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context, index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () {
                  selectContacts(index, contact);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: GoogleFonts.quicksand(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    leading: selectedContactsIndex.contains(index)
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.done_outline_rounded,
                              color: whiteColor,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return ErrorDisplayScreen(error: error.toString());
      },
      loading: () {
        return const LoaderWidget();
      },
    );
  }
}

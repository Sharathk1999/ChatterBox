import 'package:chatterbox/features/contacts_select/repository/contacts_select_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final contactsSelectRepository = ref.watch(contactSelectRepositoryProvider);
  return contactsSelectRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final contactsSelectRepository = ref.watch(contactSelectRepositoryProvider);
  return SelectContactController(
    ref: ref,
    contactsSelectRepository: contactsSelectRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final ContactsSelectRepository contactsSelectRepository;
  SelectContactController({
    required this.ref,
    required this.contactsSelectRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    contactsSelectRepository.selectContact(selectedContact, context);
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:chatterbox/features/group/repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupControllerProvider = Provider((ref) {
   final groupRepository = ref.read(groupRepositoryProvider);
   return GroupController(groupRepository: groupRepository, ref: ref);
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;
  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) {
    groupRepository.createGroup(context, name, profilePic, selectedContacts);
  }
}

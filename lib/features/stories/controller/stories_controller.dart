import 'dart:io';

import 'package:chatterbox/features/auth/controller/auth_controller.dart';
import 'package:chatterbox/features/stories/repository/stories_repository.dart';
import 'package:chatterbox/models/stories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storiesControllerProvider = Provider(
  (ref) {
    final storiesRepository = ref.read(storieRepositoryProvider);
    return StoriesController(storiesRepository: storiesRepository, ref: ref);
  },
);

class StoriesController {
  final StoriesRepository storiesRepository;
  final ProviderRef ref;
  StoriesController({
    required this.storiesRepository,
    required this.ref,
  });

  void addStories(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      storiesRepository.uploadStories(
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        storieImage: file,
        context: context,
      );
    });
  }

  Future<List<StoriesModel>> getStories(BuildContext context)async{
    List<StoriesModel> stories = await storiesRepository.getStories(context);
    return stories;
  }
}

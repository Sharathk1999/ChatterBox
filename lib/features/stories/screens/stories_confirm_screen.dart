import 'dart:io';

import 'package:chatterbox/colors.dart';
import 'package:chatterbox/features/stories/controller/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoriesConfirmScreen extends ConsumerWidget {
  static const String routeName = '/confirm-storie-screen';
  final File file;
  const StoriesConfirmScreen({
    super.key,
    required this.file,
  });

  void addStories(WidgetRef ref, BuildContext context){
    ref.read(storiesControllerProvider).addStories(file, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: () => addStories(ref, context),
        child:const Icon(Icons.done_outline_rounded,color: whiteColor,),
      ),
    );
  }
}

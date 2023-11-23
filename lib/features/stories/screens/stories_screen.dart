// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/models/stories_model.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoriesScreen extends StatefulWidget {
  static const String routeName = '/stories-screen';
  final StoriesModel stories;
  const StoriesScreen({
    Key? key,
    required this.stories,
  }) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.stories.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.stories.photoUrl[i],
          controller: controller,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const LoaderWidget()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}

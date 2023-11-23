import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/features/stories/controller/stories_controller.dart';
import 'package:chatterbox/features/stories/screens/stories_screen.dart';
import 'package:chatterbox/models/stories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoriesContactScreen extends ConsumerWidget {
  const StoriesContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StoriesModel>>(
      future: ref.read(storiesControllerProvider).getStories(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var storieData = snapshot.data![index];
            return Column(
                  children: [
                    InkWell(
                      onTap: () {
                       Navigator.pushNamed(context, StoriesScreen.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            storieData.username,
                            style: const TextStyle(
                                fontSize: 18, color: whiteColor),
                          ),
                         
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              storieData.profilePic,
                            ),
                            radius: 30,
                          ),
                          
                        ),
                      ),
                    ),
                    // const Divider(color: dividerColor, indent: 85),
                  ],
                );
          },
        );
      },
    );
  }
}

import 'dart:io';

import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/auth/controller/auth_controller.dart';
import 'package:chatterbox/features/chat/widgets/contacts_list.dart';
import 'package:chatterbox/features/contacts_select/screens/contacts_select_screen.dart';
import 'package:chatterbox/features/group/screens/group_create_screen.dart';
import 'package:chatterbox/features/stories/screens/stories_confirm_screen.dart';
import 'package:chatterbox/features/stories/screens/stories_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: Text(
            'ChatterBox',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child:  Text(
                    'Create Group',
                    style: GoogleFonts.quicksand(
                       color: whiteColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, CreateGroupScreen.routeName);
                  },
                ),
                PopupMenuItem(
                  child:  Text(
                    'Logout',
                    style: GoogleFonts.quicksand(
                       color: whiteColor,
                    ),
                  ),
                  onTap: () {
                    ref.read(authControllerProvider).signOut(context);
                  },
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(50),
              // image: DecorationImage(image: AssetImage('assets/backgroundImage.png',),fit: BoxFit.cover)
            ),
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: Colors.white60,
            unselectedLabelColor: Colors.white30,
            labelStyle: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'Chatter',
              ),
              Tab(
                text: 'Stories',
              ),
              Tab(
                text: 'Connect',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            ContactsList(),
            StoriesContactScreen(),
            Text('Connect')
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabController.index == 0) {
              Navigator.pushNamed(context, ContactsSelectScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, StoriesConfirmScreen.routeName,
                    arguments: pickedImage);
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.white38,
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/group/controller/group_controller.dart';
import 'package:chatterbox/features/group/widgets/select_contact_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = "/create-group";
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final TextEditingController groupNameController = TextEditingController();

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            image!,
            ref.read(
              selectedGroupContacts,
            ),
          );
          ref.read(selectedGroupContacts.state).update((state) => []);
           Navigator.pop(context);
    }
   
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create your group',
          style: GoogleFonts.quicksand(
            color: whiteColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.person,
                          size: 84,
                        ),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.black54,
                        backgroundImage: FileImage(
                          image!,
                        ),
                      ),
                Positioned(
                  bottom: -1,
                  right: 5,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo_rounded,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Group name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                ),
                style: GoogleFonts.quicksand(color: whiteColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Select members',
                style: GoogleFonts.quicksand(
                  color: whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
           const SelectContactsGroup()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done_outline_rounded,
          color: whiteColor,
        ),
      ),
    );
  }
}

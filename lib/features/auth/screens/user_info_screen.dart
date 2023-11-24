import 'dart:io';

import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    } else {
      showSnackBar(
          context: context, content: 'Please enter a username to continue');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
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
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter name',
                        hintStyle: GoogleFonts.quicksand(color: whiteColor),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                        ),
                      ),
                      style: GoogleFonts.quicksand(
                        color: whiteColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
                    icon: const Icon(
                      Icons.done_outline_rounded,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

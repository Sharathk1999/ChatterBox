import 'dart:io';

import 'package:chatterbox/common/utils/utils.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  static const String routeName = '/user-information';
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
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
                      decoration: const InputDecoration(
                          hintText: 'Enter name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ))),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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

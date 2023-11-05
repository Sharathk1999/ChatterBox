import 'dart:io';

import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/enums/message_enum.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomCustomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomCustomChatField({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomCustomChatField> createState() =>
      _BottomCustomChatFieldState();
}

class _BottomCustomChatFieldState extends ConsumerState<BottomCustomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );

      _messageController.clear();
      //or
      /*
          setState((){
            _messageController='';
          }) 
           */
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              }
              if (val.isEmpty) {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            style: const TextStyle(
              color: whiteColor,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.gif_box_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              hintStyle: const TextStyle(
                color: whiteColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 5,
            right: 3,
            left: 3,
          ),
          child: CircleAvatar(
            backgroundColor: mobileChatBoxColor,
            radius: 24,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShowSendButton ? Icons.send_rounded : Icons.mic,
                color: whiteColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}

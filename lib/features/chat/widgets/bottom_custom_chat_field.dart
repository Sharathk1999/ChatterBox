import 'package:chatterbox/colors.dart';
import 'package:flutter/material.dart';

class BottomCustomChatField extends StatefulWidget {
  const BottomCustomChatField({
    super.key,
  });

  @override
  State<BottomCustomChatField> createState() => _BottomCustomChatFieldState();
}

class _BottomCustomChatFieldState extends State<BottomCustomChatField> {
  bool isShowSendButton = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              }
              if (val.isEmpty) {
                setState(() {
                  isShowSendButton=false;
                });
              }
            },
            style:const TextStyle(
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
                      onPressed: () {},
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
              hintStyle:const TextStyle(
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
          padding:const EdgeInsets.only(
            bottom: 5,
            right: 3,
            left: 3,
          ),
          child: CircleAvatar(
            backgroundColor: mobileChatBoxColor,
            child: Icon(
              isShowSendButton ? Icons.send_rounded : Icons.mic,
              color: whiteColor,
            ),
          ),
        )
      ],
    );
  }
}

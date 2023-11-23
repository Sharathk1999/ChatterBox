import 'dart:io';

import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/enums/message_enum.dart';
import 'package:chatterbox/common/providers/message_reply_provider.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/chat/controller/chat_controller.dart';
import 'package:chatterbox/features/chat/widgets/reply_message_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomCustomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const BottomCustomChatField({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<BottomCustomChatField> createState() =>
      _BottomCustomChatFieldState();
}

class _BottomCustomChatFieldState extends ConsumerState<BottomCustomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
            widget.isGroupChat,
          );

      _messageController.clear();
      //or
      /*
          setState((){
            _messageController='';
          }) 
           */
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
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
          widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      if (context.mounted) {
        ref.read(chatControllerProvider).sendGIFMessage(
              context,
              gif.url,
              widget.receiverUserId,
              widget.isGroupChat,
            );
      }
    }
  }

  void hideEmoji() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void showEmoji() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus;

  void toggleEmojiKeyboard() {
    if (isShowEmoji) {
      showKeyboard();
      hideEmoji();
    } else {
      hideKeyboard();
      showEmoji();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const ReplyMessagePreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
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
                            onPressed: toggleEmojiKeyboard,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectGIF,
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
                          onPressed: selectVideo,
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
                    isShowSendButton
                        ? Icons.send_rounded
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmoji
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

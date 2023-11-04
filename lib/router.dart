

import 'package:chatterbox/common/widgets/error_display.dart';
import 'package:chatterbox/features/auth/screens/login_screen.dart';
import 'package:chatterbox/features/auth/screens/otp_screen.dart';
import 'package:chatterbox/features/auth/screens/user_info_screen.dart';
import 'package:chatterbox/features/contacts_select/screens/contacts_select_screen.dart';
import 'package:chatterbox/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) =>const  LoginScreen(),
      );

      case OTPScreen.routeName:
              final verficationID = settings.arguments as String;
      return MaterialPageRoute(

        builder: (context) =>  OTPScreen(
          verificationID: verficationID,
        ),
      );

       case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (context) =>const  UserInfoScreen(),
      );

       case ContactsSelectScreen.routeName:
      return MaterialPageRoute(
        builder: (context) =>const  ContactsSelectScreen(),
      );

       case MobileChatScreen.routeName:
       final arguments = settings.arguments as Map<String, dynamic>;
       final name = arguments['name'];
       final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) =>  MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorDisplayScreen(error: 'This screen does not exits'),
        ),
      );
  }
}

import 'package:chatterbox/colors.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  static const String routeName = '/user-information';
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text('User Info'),
        elevation: 1,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
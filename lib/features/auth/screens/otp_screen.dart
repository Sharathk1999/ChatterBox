import 'package:chatterbox/colors.dart';
import 'package:chatterbox/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationID;
  const OTPScreen({super.key, required this.verificationID});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          verificationID,
          userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(' verifiying phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'we sent an otp to your number',
              style: TextStyle(color: whiteColor),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: whiteColor)),
                    hintText: '- - - - - -',
                    hintStyle: const TextStyle(
                      color: whiteColor,
                    ),
                  ),
                  style: const TextStyle(
                    color: whiteColor,
                    fontSize: 28,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length == 6) {
                      verifyOTP(
                        ref,
                        context,
                        value.trim(),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

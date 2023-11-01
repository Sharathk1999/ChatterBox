import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/widgets/custom_button.dart';
import 'package:chatterbox/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navToLoginScreen(BuildContext context){
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 55,
              ),
          const    Text(
                'Welcome to ChatterBox',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
              SizedBox(
                height: size.height / 10,
              ),
              const CircleAvatar(
                radius: 150,
                backgroundImage: AssetImage(
                  'assets/chatterBox_loginbg.png',
                ),
              ),
              SizedBox(
                height: size.height / 10,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Read our privacy policy and tap Agree and Countinue to \n accept the terms and conditions.',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  text: 'Agree and Continue',
                  onPressed: () => navToLoginScreen(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

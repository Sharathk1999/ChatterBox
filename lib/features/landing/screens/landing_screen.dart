import 'package:chatterbox/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 55,
            ),
            Text(
              'Welcome to ChatterBox',
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.w600,
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
              width: size.width * .75,
              child: CustomButton(
                text: 'Agree and Countinue',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

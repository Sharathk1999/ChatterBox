import 'package:chatterbox/colors.dart';
import 'package:chatterbox/common/custom_button.dart';
import 'package:chatterbox/common/utils/utils.dart';
import 'package:chatterbox/features/auth/repository/auth_repository.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      countryListTheme: const CountryListThemeData(
          backgroundColor: backgroundColor,
          bottomSheetHeight: 500,
          searchTextStyle: TextStyle(color: whiteColor),
          textStyle: TextStyle(
            color: whiteColor,
          )),
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authRepositoryProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(
          context: context, content: 'Fill country code and phone number');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter phone number',
          style: TextStyle(fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ChatterBox will verify your phone number',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            TextButton(
              onPressed: pickCountry,
              child: const Text('Choose Country'),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                if (country != null)
                  Text(
                    '+${country!.phoneCode}',
                    style: const TextStyle(
                      color: whiteColor,
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    style: const TextStyle(color: whiteColor),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'phone number here',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: whiteColor),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: whiteColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.5,
            ),
            SizedBox(
              width: 120,
              child: CustomButton(
                text: 'Continue',
                onPressed: sendPhoneNumber,
              ),
            )
          ],
        ),
      ),
    );
  }
}

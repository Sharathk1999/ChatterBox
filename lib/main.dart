import 'package:chatterbox/common/widgets/error_display.dart';
import 'package:chatterbox/common/widgets/loader.dart';
import 'package:chatterbox/features/auth/controller/auth_controller.dart';
import 'package:chatterbox/features/landing/screens/landing_screen.dart';
import 'package:chatterbox/firebase_options.dart';
import 'package:chatterbox/router.dart';
import 'package:chatterbox/screens/mobile_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatterBox',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, stackTrace) {
              return ErrorDisplayScreen(
                  error: 'this is err =>${err.toString()}');
            },
            loading: () => const LoaderWidget(),
          ),
    );
  }
}


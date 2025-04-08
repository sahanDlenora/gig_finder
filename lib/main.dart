import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gig_finder/firebase_options.dart';
import 'package:gig_finder/router/router.dart';
import 'package:gig_finder/utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        //brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xff2a8a25),
          contentTextStyle: TextStyle(
            color: mainWhiteColor,
            fontSize: 16,
          ),
        ),
      ),
      routerConfig: RouterClass().router,
    );
  }
}

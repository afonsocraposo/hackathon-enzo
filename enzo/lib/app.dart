import 'package:enzo/home_page.dart';
import 'package:enzo/workout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackthon',
      debugShowCheckedModeBanner: false,
      // home: const HomePage(title: 'HACKATHON', url: ''),
      theme: ThemeData(
        primaryColor: Color(0xFF456990),
        colorScheme: ColorScheme.light(
            primary: Color(0xFF456990), secondary: Color(0xFFF45B69)),
        textTheme: GoogleFonts.comfortaaTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
    );
  }
}

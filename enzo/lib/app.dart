import 'package:enzo/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hackthon',
      debugShowCheckedModeBanner: false,
     // home: const HomePage(title: 'HACKATHON', url: ''),
      home: HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Screens/Homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme:
              GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
          accentColor: Colors.blueGrey),
      home: Homepage()
    );
  }
}

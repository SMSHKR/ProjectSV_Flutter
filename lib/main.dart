import 'package:flutter/material.dart';
import 'package:projectsv_flutter/views/home_page.dart';

void main() {
  runApp(new MaterialApp(
    title: "Signature Verification",
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      primaryColor: Colors.cyan,
      accentColor: Colors.cyanAccent
    ),
    home: HomePage(),
  ));
}

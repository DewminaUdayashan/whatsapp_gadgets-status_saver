import 'package:flutter/material.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';

class Themes {
  late var t;

  static final theme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      accentColor: darkGrey,
      canvasColor: Colors.white70,
      textTheme: textTheme,
      iconTheme: const IconThemeData(
        color: Colors.black54,
      ));

  static final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: darkGrey,
      accentColor: Colors.white,
      canvasColor: Colors.grey[700],
      textTheme: darkTextTheme,
      iconTheme: const IconThemeData(
        color: Colors.white70,
      ));

  static TextTheme textTheme = const TextTheme(
    headline4: TextStyle(
      fontSize: 35,
      color: Colors.black54,
      fontWeight: FontWeight.w800,
    ),
    headline6: TextStyle(
      fontSize: 20,
      color: Colors.black54,
    ),
    headline5: TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = const TextTheme(
    headline4: TextStyle(
      fontSize: 35,
      color: Colors.white,
      fontWeight: FontWeight.w800,
    ),
    headline6: TextStyle(
      fontSize: 20,
      color: Colors.white70,
    ),
    headline5: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
  );
}

import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Color.fromARGB(255, 71, 200, 160),
        onSecondary: Colors.white,
      ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Color.fromARGB(255, 160, 203, 225),
        onPrimary: Color.fromARGB(255, 255, 255, 255),
        secondary: Color.fromARGB(255, 71, 200, 160),
        onSecondary: Color.fromARGB(255, 255, 255, 255),
      ),
);
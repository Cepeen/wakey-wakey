import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final whiteTheme = ThemeData(
    primaryColor: Color(0xFFAAAAAA),
    appBarTheme: AppBarTheme(
      color: Color(0xFFAAAAAA),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFBEBEBE)),
    scaffoldBackgroundColor: Color(0xFFFCFCFC),
    textTheme: TextTheme(
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.grey),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey[400],
      textTheme: ButtonTextTheme.primary,
    ),
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 201, 201, 201),
    ));

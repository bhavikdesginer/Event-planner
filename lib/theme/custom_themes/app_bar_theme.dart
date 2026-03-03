import 'package:flutter/material.dart';

class CAppBarTheme {
  CAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    shadowColor: Colors.transparent,
    centerTitle: true,
    scrolledUnderElevation: 10,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        color: Colors.black),
  );
}

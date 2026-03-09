import 'package:flutter/material.dart';

import '../app_theme.dart';

class CTextButtonTheme {
  CTextButtonTheme._();

  static final lightTextButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
        backgroundColor: Colors.transparent,
        textStyle: const TextStyle(
            fontSize: 16, color: AppTheme.colorPrimary, fontWeight: FontWeight.w600),
        alignment: Alignment.center,
        elevation: 2),);

  static final darkTextButtonThemeData = TextButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
}

import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CElevatedButtonTheme {
  CElevatedButtonTheme._();

  static final lightElevatedButtonThemeData = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AppTheme.colorPrimary,
    disabledForegroundColor: Colors.grey,
    disabledBackgroundColor: Colors.grey,
    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
    textStyle: const TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  ));
}

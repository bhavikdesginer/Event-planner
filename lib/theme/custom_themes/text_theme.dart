import 'package:flutter/material.dart';
import '../app_theme.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        color: AppTheme.colorPrimary),
    headlineMedium: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w900,
        color: AppTheme.colorPrimary),
    headlineSmall: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w900,
        color: AppTheme.colorPrimary),
    titleLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.colorBlack),
    titleMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.colorBlack),
    titleSmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.colorBlack),
    bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.colorTextColor),
    bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.colorTextColor),
    bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppTheme.colorTextColor),
    labelLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    labelMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    labelSmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
  );
}

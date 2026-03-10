import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_themes/app_bar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_button_theme.dart';
import 'custom_themes/text_form_field_theme.dart';
import 'custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static const Color colorPrimary = Color(0xFFFF8142);
  static const Color colorBlack = Color(0xFF242424);
  static const Color colorGrey = Color(0xff797979);
  static const Color colorTextColor = Color(0xff51575d);
  static const Color colorLightGrey = Color(0xfff6f6f6);

  static ThemeData lightThemeData = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Color(0xffe6e6f2),// slight purple
      tertiary: Color(0xffe0e0e0)
    ),
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: Brightness.light,
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: CTextTheme.lightTextTheme,
    textButtonTheme: CTextButtonTheme.lightTextButtonThemeData,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppTheme.colorPrimary, // Set the cursor color
      selectionColor: AppTheme.colorPrimary.withOpacity(0.3),
      selectionHandleColor: AppTheme.colorPrimary,
    ),
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonThemeData,
    outlinedButtonTheme: COutlinedButtonTheme.lightElevatedButtonThemeData,
    appBarTheme: CAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: CBottomSheetTheme.lightBottomSheetTheme,
    chipTheme: CChipTheme.lightChipTheme,
    checkboxTheme: CChackboxTheme.lightCheckboxTheme,
    inputDecorationTheme: CTextFormFieldTheme.lightInputDecorationTheme,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white,
      height: 60,
      padding: EdgeInsets.zero
    ),
    snackBarTheme: const SnackBarThemeData(
        actionTextColor: colorLightGrey, backgroundColor: colorTextColor),
    // dropdownMenuTheme: DropdownMenuThemeData(
    //   textStyle: TextStyle(
    //     color: Colors.blue,
    //     fontSize: 16,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   inputDecorationTheme: InputDecorationTheme(
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(color: Colors.green),
    //     ),
    //     filled: true,
    //     fillColor: Colors.red,
    //   ),
    //   menuStyle: MenuStyle(
    //     elevation: WidgetStateProperty.all(8),
    //     shape: WidgetStateProperty.all(RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     )),
    //   ),
    // )
  );
}

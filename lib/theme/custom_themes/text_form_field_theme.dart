import 'package:flutter/material.dart';

import '../app_theme.dart';

class CTextFormFieldTheme {
  CTextFormFieldTheme._();

  static final lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
// constraints: const BoxConstraints.expand (height: 14.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.grey.shade500),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.grey.shade400),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:
        const TextStyle().copyWith(color: Colors.black.withOpacity(0.8)),
    // border: InputBorder.none,
    // enabledBorder: InputBorder.none,
    // focusedBorder: InputBorder.none,
    // errorBorder: InputBorder.none,
    // focusedErrorBorder: InputBorder.none,
    fillColor: Colors.grey.shade200,
    filled: true,
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade200,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppTheme.colorPrimary,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(12.0),
    ),
  );

  static final darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
// constraints: const BoxConstraints.expand (height: 14.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:
        const TextStyle().copyWith(color: Colors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: Colors.grey)),

    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.black12),
    ),

    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 2, color: Colors.orange)),
  );
}

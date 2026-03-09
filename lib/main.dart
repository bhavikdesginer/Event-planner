import 'package:eventhub/pages/home_page.dart';
import 'package:eventhub/pages/login_flow/splash_page.dart';
import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        title: 'EventHub',
        theme: AppTheme.lightThemeData,
        debugShowCheckedModeBanner: false,
        home: const SplashPage()
      ),
    );
  }
}

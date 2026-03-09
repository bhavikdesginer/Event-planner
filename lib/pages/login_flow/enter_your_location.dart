import 'package:flutter/material.dart';

class EnterYourLocation extends StatefulWidget {
  const EnterYourLocation({super.key});

  @override
  State<EnterYourLocation> createState() => _EnterYourLocationState();
}

class _EnterYourLocationState extends State<EnterYourLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your Location"),
        centerTitle: true,
      )
    );
  }
}

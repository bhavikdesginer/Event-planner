import 'dart:io';

import 'package:eventhub/pages/login_flow/enter_gender_page.dart';
import 'package:eventhub/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../theme/app_theme.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key});

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verify Code",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: AppTheme.colorBlack),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Please enter code we just sent to email",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),
            Text(
              "example@email.com",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppTheme.colorPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            OtpInput(
              length: 4,
              onCompleted: (otp) {
                print("OTP Entered: $otp");
              },
            ),
            const SizedBox(height: 40),
            Text(
              "Didn't receive OTP?",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),
            Text(
              "Resend code",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.colorBlack,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.colorBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CommonFunctionClass.pageRouteBuilder(
                          const EnterGenderPage()));
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}

import 'package:eventhub/theme/app_theme.dart';
import 'package:eventhub/widgets/custom_checkbox.dart';
import 'package:eventhub/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/CommonFuctions.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool checkBoxFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Account",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppTheme.colorBlack),
              ),
              const SizedBox(height: 20),
              Text(
                "Fill your information below or register\nwith your social account",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.colorGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const CustomTextField(
                  title: "Name", hint: "Enter name", type: TextInputType.text),
              const CustomTextField(
                  title: "Email",
                  hint: "Enter email",
                  type: TextInputType.emailAddress),
              const CustomTextField(
                title: "Password",
                hint: "Enter password",
                type: TextInputType.emailAddress,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomCheckbox(
                    value: checkBoxFlag,
                    onChanged: (val) => setState(() => checkBoxFlag = val),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      text: "Agree with ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Terms & Conditions",
                          style: const TextStyle(
                            color: AppTheme.colorPrimary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.colorPrimary,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CommonFunctionClass.pageRouteBuilder(
                            const LoginPage()));
                  },
                  child: const Text("Sign up")),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: const TextStyle(
                        color: AppTheme.colorPrimary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.colorPrimary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            CommonFunctionClass.pageRouteBuilder(
                                const LoginPage()),
                          );
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

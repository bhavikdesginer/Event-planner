import 'package:eventhub/pages/login_flow/email_verify_page.dart';
import 'package:eventhub/pages/login_flow/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                "Sign In",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppTheme.colorBlack),
              ),
              const SizedBox(height: 20),
              Text(
                "Hi! Welcome Back, you've been missed",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.colorGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: AppTheme.colorPrimary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.colorPrimary,
                        fontSize: 12),
                  )
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,CommonFunctionClass.pageRouteBuilder(EmailVerifyPage()));
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   CommonFunctionClass.pageRouteBuilder(const HomePage()),
                    //       (route) => route.isCurrent,
                    // );
                  },
                  child: const Text("Sign In")),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "Sign Up",
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
                                const RegisterPage()),
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

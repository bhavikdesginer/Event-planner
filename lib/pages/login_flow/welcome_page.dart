import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/pages/login_flow/register_page.dart';
import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/welcome_image.png"),
              const SizedBox(height: 100),
              Text(
                "Unlock the Future of",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Text(
                "Event Booking App",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.colorPrimary),
              ),
              const SizedBox(height: 20),
              Text(
                "Transforming the way you \ndiscover and book events effortlessly.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.colorGrey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        CommonFunctionClass.pageRouteBuilder(const RegisterPage()));
                  },
                  child: const Text("Let's get started")),
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
                            CommonFunctionClass.pageRouteBuilder(const LoginPage()),
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

import 'package:eventhub/pages/login_flow/enter_gender_page.dart';
import 'package:eventhub/pages/login_flow/register_page.dart';
import 'package:eventhub/pages/nav_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../helper/LoadingDialog.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_textfield.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // ← CONTROLLERS + SERVICES
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

              // ← UPDATED: added controllers
              CustomTextField(
                title: "Email",
                hint: "Enter email",
                type: TextInputType.emailAddress,
                controller: emailController,
              ),
              CustomTextField(
                title: "Password",
                hint: "Enter password",
                type: TextInputType.visiblePassword,
                isPassword: true,
                controller: passwordController,
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

              // ← UPDATED: Firebase email login
              ElevatedButton(
                onPressed: () async {
                  LoadingDialog.showLoadingDialog(context);
                  try {
                    final user = await _auth.loginWithEmail(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    Navigator.pop(context); // close loader
                    if (user != null) {
                      final done = await _userService.isOnboardingDone(user.uid);
                      Navigator.pushAndRemoveUntil(
                        context,
                        CommonFunctionClass.pageRouteBuilder(
                          done ? NavPage(index: 0) : const EnterGenderPage(),
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    CommonFunctionClass.showSnackBar(e.toString(), context);
                  }
                },
                child: const Text("Sign In"),
              ),

              const SizedBox(height: 12),

              // ← NEW: Google Sign In button
              OutlinedButton.icon(
                onPressed: () async {
                  LoadingDialog.showLoadingDialog(context);
                  try {
                    final user = await _auth.signInWithGoogle();
                    Navigator.pop(context);
                    if (user != null) {
                      final done = await _userService.isOnboardingDone(user.uid);
                      Navigator.pushAndRemoveUntil(
                        context,
                        CommonFunctionClass.pageRouteBuilder(
                          done ? NavPage(index: 0) : const EnterGenderPage(),
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    CommonFunctionClass.showSnackBar(e.toString(), context);
                  }
                },
                icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 28),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),

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
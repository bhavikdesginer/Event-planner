import 'package:eventhub/theme/app_theme.dart';
import 'package:eventhub/widgets/custom_checkbox.dart';
import 'package:eventhub/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../helper/CommonFuctions.dart';
import '../../helper/LoadingDialog.dart';
import '../../helper/onboarding_data.dart';
import 'email_verify_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool checkBoxFlag = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();

  Future<void> _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      CommonFunctionClass.showSnackBar(
        "Please fill all required fields",
        context,
      );
      return;
    }

    if (phone.length != 10) {
      CommonFunctionClass.showSnackBar(
        "Phone number must be exactly 10 digits",
        context,
      );
      return;
    }

    if (!checkBoxFlag) {
      CommonFunctionClass.showSnackBar(
        "Please agree to Terms & Conditions",
        context,
      );
      return;
    }

    LoadingDialog.showLoadingDialog(context);
    try {
      final user = await _auth.registerWithEmail(email, password);
      if (user == null) {
        throw Exception("Registration failed");
      }

      await _userService.saveUser(
        UserModel(
          uid: user.uid,
          name: name,
          email: email,
          phone: phone,
          gender: '',
          age: 0,
          interests: [],
          location: '',
        ),
      );

      OnboardingData.name = name;
      OnboardingData.email = email;
      OnboardingData.password = password;
      OnboardingData.phone = phone;

      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        CommonFunctionClass.pageRouteBuilder(const EmailVerifyPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      CommonFunctionClass.showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
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

              CustomTextField(
                title: "Name",
                hint: "Enter name",
                type: TextInputType.text,
                controller: nameController,
              ),
              CustomTextField(
                title: "Email",
                hint: "Enter email",
                type: TextInputType.emailAddress,
                controller: emailController,
              ),
              CustomTextField(
                title: "Phone",
                hint: "Enter phone number",
                type: TextInputType.phone,
                controller: phoneController,
                isMobile: true,
              ),  
              CustomTextField(
                title: "Password",
                hint: "Enter password",
                type: TextInputType.visiblePassword,
                isPassword: true,
                controller: passwordController,
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
                onPressed: _register,
                child: const Text("Sign up"),
              ),

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
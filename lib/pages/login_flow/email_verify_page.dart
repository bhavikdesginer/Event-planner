import 'package:eventhub/pages/login_flow/enter_gender_page.dart';
import 'package:eventhub/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../helper/LoadingDialog.dart';
import '../../helper/onboarding_data.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key});

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {

  final AuthService _auth = AuthService();
  final UserService _userService = UserService();
  String _otp = ''; // ← stores OTP entered by user

  @override
  void initState() {
    super.initState();
    _sendOTP(); // ← auto send OTP when page opens
  }

  // ── SEND OTP ──────────────────────────────────────────
  void _sendOTP() async {
    await _auth.sendOTP(
      phoneNumber: '+91${OnboardingData.phone}',
      onCodeSent: (verificationId) {
        OnboardingData.verificationId = verificationId;
      },
      onError: (error) {
        CommonFunctionClass.showSnackBar(error, context);
      },
    );
  }

  // ── VERIFY OTP + REGISTER USER ────────────────────────
  void _verifyAndRegister() async {
    if (_otp.length < 4) {
      CommonFunctionClass.showSnackBar("Please enter the OTP", context);
      return;
    }

    LoadingDialog.showLoadingDialog(context);
    try {
      // Step 1: Verify phone OTP (this signs in the phone-auth user)
      await _auth.verifyOTP(
        verificationId: OnboardingData.verificationId,
        otp: _otp,
      );

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated after OTP verification");
      }

      // Step 2: Save basic user info to Firestore
      await _userService.saveUser(UserModel(
        uid: user.uid,
        name: OnboardingData.name,
        email: OnboardingData.email,
        phone: OnboardingData.phone,
        gender: '',
        age: 0,
        interests: [],
        location: '',
      ));

      Navigator.pop(context); // close loader
      Navigator.push(
        context,
        CommonFunctionClass.pageRouteBuilder(const EnterGenderPage()),
      );
    } catch (e) {
      Navigator.pop(context); // close loader
      CommonFunctionClass.showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),

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
              "Please enter the OTP sent to your phone",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),

            // ← Shows actual phone number from OnboardingData
            Text(
              '+91 ${OnboardingData.phone}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppTheme.colorPrimary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // ← OTP input, saves value to _otp
            OtpInput(
              length: 4,
              onCompleted: (otp) {
                _otp = otp;
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

            // ← Resend OTP on tap
            GestureDetector(
              onTap: _sendOTP,
              child: Text(
                "Resend code",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.colorBlack,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.colorBlack),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // ← UPDATED: calls _verifyAndRegister
            ElevatedButton(
              onPressed: _verifyAndRegister,
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
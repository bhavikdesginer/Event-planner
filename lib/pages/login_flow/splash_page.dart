import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/pages/login_flow/welcome_page.dart';
import 'package:eventhub/pages/login_flow/enter_gender_page.dart';
import 'package:eventhub/pages/nav_page.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();

  Future<void> _routeUser() async {
    try {
      // Check if user is already logged in
      final user = _auth.currentUser;
      
      if (user == null) {
        // Not logged in, show welcome/login page
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          CommonFunctionClass.pageRouteBuilder(const WelcomePage()),
        );
        return;
      }

      // User is logged in, check onboarding status
      final onboardingDone = await _userService.isOnboardingDone(user.uid);

      if (!mounted) return;

      if (onboardingDone) {
        // Onboarding complete, go to home
        Navigator.pushReplacement(
          context,
          CommonFunctionClass.pageRouteBuilder(NavPage(index: 0)),
        );
      } else {
        // Onboarding incomplete, go to gender selection
        Navigator.pushReplacement(
          context,
          CommonFunctionClass.pageRouteBuilder(const EnterGenderPage()),
        );
      }
    } catch (e) {
      // On error, show login page
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CommonFunctionClass.pageRouteBuilder(const WelcomePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Delay for splash animation, then check auth state
    Future.delayed(const Duration(milliseconds: 1500), _routeUser);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorPrimary,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.confirmation_num,size: 50,color: AppTheme.colorPrimary),
              ),
              Text("Event Booking",style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.w700
              ),)
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:eventhub/pages/login_flow/enter_gender_page.dart';
import 'package:eventhub/pages/login_flow/welcome_page.dart';
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
  Timer? _timer;

  void _go(Widget page) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> _routeUser() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        _go(const WelcomePage());
        return;
      }

      final onboardingDone = await _userService
          .isOnboardingDone(user.uid)
          .timeout(const Duration(seconds: 8), onTimeout: () => false);

      if (onboardingDone) {
        _go(const NavPage(index: 0));
      } else {
        _go(const EnterGenderPage());
      }
    } catch (_) {
      _go(const WelcomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), _routeUser);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.confirmation_num,
                size: 50,
                color: AppTheme.colorPrimary,
              ),
            ),
            Text(
              "Event Booking",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

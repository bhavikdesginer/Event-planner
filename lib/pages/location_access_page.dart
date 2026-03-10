import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/helper/LoadingDialog.dart';
import 'package:eventhub/helper/onboarding_data.dart';
import 'package:eventhub/pages/nav_page.dart';
import 'package:eventhub/services/auth_service.dart';
import 'package:eventhub/services/user_service.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LocationAccessPage extends StatefulWidget {
  const LocationAccessPage({super.key});

  @override
  State<LocationAccessPage> createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {

  final AuthService _auth = AuthService();
  final UserService _userService = UserService();

  // ── SAVE ALL ONBOARDING DATA TO FIRESTORE ─────────────
  Future<void> _completeOnboarding(String location) async {
    LoadingDialog.showLoadingDialog(context);
    try {
      final uid = _auth.currentUser!.uid;

      await _userService.updateUser(uid, {
        'gender': OnboardingData.gender,
        'age': OnboardingData.age,
        'interests': OnboardingData.interests,
        'location': location,
      });

      if (!mounted) return;

      OnboardingData.clear(); // ← clean up temp data

      Navigator.pop(context); // close loader
      Navigator.pushAndRemoveUntil(
        context,
        CommonFunctionClass.pageRouteBuilder(NavPage(index: 0)),
        (route) => false, // ← clears entire back stack
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loader
      CommonFunctionClass.showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(35),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.colorLightGrey,
              ),
              child: const Icon(
                Icons.location_pin,
                color: AppTheme.colorPrimary,
                size: 80,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "What is Your Location?",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppTheme.colorBlack),
            ),
            const SizedBox(height: 20),
            Text(
              "To Find Nearby Events, Share Your Location with Us",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // ← UPDATED: saves onboarding data then goes to NavPage
            ElevatedButton(
              onPressed: () => _completeOnboarding('Current Location'),
              child: const Text("Allow Location Access"),
            ),

            const SizedBox(height: 10),

            // ← UPDATED: saves onboarding data then goes to manual location
            TextButton(
              onPressed: () => _completeOnboarding('Manual'),
              child: const Text(
                "Enter Location Manually",
                style: TextStyle(color: AppTheme.colorPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
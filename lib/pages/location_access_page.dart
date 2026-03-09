import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/pages/home_page.dart';
import 'package:eventhub/pages/login_flow/enter_your_location.dart';
import 'package:eventhub/pages/nav_page.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LocationAccessPage extends StatefulWidget {
  const LocationAccessPage({super.key});

  @override
  State<LocationAccessPage> createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {
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
                color: AppTheme.colorLightGrey
              ),
              child: const Icon(Icons.location_pin,color: AppTheme.colorPrimary,
              size: 80),
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
            ElevatedButton(onPressed: (){
              Navigator.push(context, CommonFunctionClass.pageRouteBuilder(NavPage(index: 0)));
            }, child: const Text("Allow Location Access")),
            const SizedBox(height: 10),
            TextButton(onPressed: (){
              Navigator.push(context, CommonFunctionClass.pageRouteBuilder(const EnterYourLocation()));
            }, child: const Text("Enter Location Manually",style: TextStyle(color: AppTheme.colorPrimary),))
          ],
        ),
      ),
    );
  }
}

import 'package:eventhub/helper/CommonFuctions.dart';
import 'package:eventhub/pages/login_flow/welcome_page.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500)).then((onValue){
      Navigator.pushReplacement(context,CommonFunctionClass.pageRouteBuilder(const WelcomePage()));
    });
    super.initState();
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

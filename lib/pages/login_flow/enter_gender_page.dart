import 'package:eventhub/pages/login_flow/enter_age_page.dart';
import 'package:eventhub/widgets/step_progress_bar.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gender_options_widget.dart';

class EnterGenderPage extends StatefulWidget {
  const EnterGenderPage({super.key});

  @override
  State<EnterGenderPage> createState() => _EnterGenderPageState();
}

class _EnterGenderPageState extends State<EnterGenderPage> {
  String selectedGender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StepProgressBar(currentStep: 1, totalSteps: 3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              "Tell Us About Yourself!",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppTheme.colorBlack),
            ),
            const SizedBox(height: 20),
            Text(
              "To enhance your experience, please tell us about your gender",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            GenderOption(
              icon: Icons.male,
              label: "Male",
              selected: selectedGender == "Male",
              onTap: () {
                setState(() => selectedGender = "Male");
              },
            ),
            const SizedBox(height: 10),
            GenderOption(
              icon: Icons.female,
              label: "Female",
              selected: selectedGender == "Female",
              onTap: () {
                setState(() => selectedGender = "Female");
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print("Selected Gender: $selectedGender");
                Navigator.push(
                  context,
                  CommonFunctionClass.pageRouteBuilder(
                    const EnterAgePage(),
                  ),
                );
              },
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}

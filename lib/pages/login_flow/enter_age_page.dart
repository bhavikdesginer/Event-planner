import 'package:eventhub/pages/login_flow/select_interests_page.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../theme/app_theme.dart';
import '../../widgets/step_progress_bar.dart';
import '../../helper/onboarding_data.dart';

class EnterAgePage extends StatefulWidget {
  const EnterAgePage({super.key});

  @override
  State<EnterAgePage> createState() => _EnterAgePageState();
}

class _EnterAgePageState extends State<EnterAgePage> {
  late FixedExtentScrollController _scrollController;

  int _selectedAge = 18;

  @override
  void initState() {
    super.initState();

    _scrollController = FixedExtentScrollController(initialItem: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _animateToAge(_selectedAge);
      });
    });
  }

  void _animateToAge(int age) {
    _scrollController.animateToItem(
      age - 1,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StepProgressBar(currentStep: 2, totalSteps: 3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              "How Old Are You?",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppTheme.colorBlack),
            ),
            const SizedBox(height: 20),
            Text(
              "This helps us to find age-specific events",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            SizedBox(
              height: 250,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 60,
                perspective: 0.002,
                diameterRatio: 1.6,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedAge = index + 1;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 100, // 1 to 100
                  builder: (context, index) {
                    final age = index + 1;
                    final isSelected = _selectedAge == age;

                    return Center(
                      child: Text(
                        "$age",
                        style: TextStyle(
                          fontSize: isSelected ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppTheme.colorPrimary
                              : Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () 
              {
                OnboardingData.age = _selectedAge;
                Navigator.push(
                  context,
                  CommonFunctionClass.pageRouteBuilder(
                    const SelectInterestsPage(),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

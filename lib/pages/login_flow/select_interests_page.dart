import 'package:eventhub/helper/onboarding_data.dart';
import 'package:eventhub/pages/location_access_page.dart';
import 'package:flutter/material.dart';
import '../../helper/CommonFuctions.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_chip_widget.dart';
import '../../widgets/step_progress_bar.dart';

class SelectInterestsPage extends StatefulWidget {
  const SelectInterestsPage({super.key});

  @override
  State<SelectInterestsPage> createState() => _SelectInterestsPageState();
}

class _SelectInterestsPageState extends State<SelectInterestsPage> {
  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.sports_esports, "label": "Gaming"},
    {"icon": Icons.music_note, "label": "Music"},
    {"icon": Icons.menu_book, "label": "Book"},
    {"icon": Icons.language, "label": "Language"},
    {"icon": Icons.camera_alt, "label": "Photography"},
    {"icon": Icons.checkroom, "label": "Fashion"},
    {"icon": Icons.eco, "label": "Nature"},
    {"icon": Icons.fitness_center, "label": "Fitness"},
    {"icon": Icons.pets, "label": "Animal"},
    {"icon": Icons.brush, "label": "Arts"},
    {"icon": Icons.sports_soccer, "label": "Sports"},
    {"icon": Icons.attach_money, "label": "Finance"},
    {"icon": Icons.lightbulb, "label": "Technology"},
    {"icon": Icons.business_center, "label": "Business"},
    {"icon": Icons.flight, "label": "Travel"},
    {"icon": Icons.directions_car, "label": "Cars"},
    {"icon": Icons.directions_run, "label": "Dance"},
    {"icon": Icons.school, "label": "Workshop"},
  ];

  final List<String> selected = [];

  void _toggleCategory(String label) {
    setState(() {
      if (selected.contains(label)) {
        selected.remove(label);
      } else {
        if (selected.length < 5) {
          selected.add(label);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can select a maximum of 5 interests."),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StepProgressBar(currentStep: 3, totalSteps: 3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              "Select upto 5 interests",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppTheme.colorBlack),
            ),
            const SizedBox(height: 20),
            Text(
              "Personalise your Event Journey by Choosing Your Interests",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.colorGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: categories.map((cat) {
                return CategoryChip(
                  icon: cat["icon"],
                  label: cat["label"],
                  selected: selected.contains(cat["label"]),
                  onTap: () => _toggleCategory(cat["label"]),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            const SizedBox(height: 30),
            ElevatedButton(
  onPressed: () {
    OnboardingData.interests = List<String>.from(selected); // ← ADD THIS
    Navigator.push(
      context,
      CommonFunctionClass.pageRouteBuilder(
        const LocationAccessPage(),
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

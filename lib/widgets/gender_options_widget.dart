import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: selected ? AppTheme.colorPrimary : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 85,
                  color: selected ? Colors.white : AppTheme.colorBlack,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? Colors.white : AppTheme.colorBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

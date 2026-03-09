import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color? activeColor;
  final Color? borderColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 22,
    this.activeColor,
    this.borderColor,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentValue = !currentValue;
        });
        widget.onChanged(currentValue);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: currentValue
              ? (widget.activeColor ?? AppTheme.colorPrimary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: widget.borderColor ??
                (currentValue
                    ? AppTheme.colorPrimary
                    : Colors.grey.shade400),
            width: 2,
          ),
        ),
        child: currentValue
            ? Icon(
          Icons.check,
          size: widget.size * 0.6,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}

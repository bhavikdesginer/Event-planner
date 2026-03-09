import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.options,
    this.initialValue,
    required this.hint,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String? _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.initialValue ?? null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null &&
        !widget.options.contains(widget.initialValue)) {
      throw Exception('Initial value is not in the options list');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              hint: Text(
                widget.hint,
                style: Theme.of(context).textTheme.bodySmall),
              value: _selectedValue,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              style: TextStyle(color: Colors.black54),
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedValue = newValue ?? '';
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              },
              items:
              widget.options.map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                  value: value,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall)
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
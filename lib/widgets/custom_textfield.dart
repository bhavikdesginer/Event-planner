import 'package:eventhub/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final String hint;
  final TextInputType type;
  final TextEditingController? controller;
  final ValueChanged<String>? onValueChanged;
  final IconData? iconData;
  final bool? readOnly;
  final bool? isMobile;
  final bool? isPassword;

  const CustomTextField(
      {super.key,
        required this.title,
        this.onValueChanged,
        this.isMobile,
        this.iconData,
        required this.hint,
        required this.type,
        this.readOnly,
        this.controller,
        this.isPassword,
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureTextFlag;

  @override
  void initState() {
    super.initState();
    obscureTextFlag = widget.isPassword == true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.type,
              cursorColor: AppTheme.colorPrimary,
              onChanged: widget.onValueChanged,
              readOnly: widget.readOnly ?? false,
              obscureText: widget.isPassword == true ? obscureTextFlag : false,
              inputFormatters: widget.isMobile == true
                  ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
                  : null,

              decoration: InputDecoration(
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: widget.hint,
                hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 14),

                // Show toggle button only if password
                suffixIcon: widget.isPassword == true
                    ? IconButton(
                  icon: Icon(
                    obscureTextFlag
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureTextFlag = !obscureTextFlag;
                    });
                  },
                )
                    : (widget.iconData != null
                    ? Icon(widget.iconData)
                    : null),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.colorPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


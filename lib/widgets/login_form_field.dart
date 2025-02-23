import 'package:flutter/material.dart';
import '../utils/text_utils.dart';

class LoginFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextStyleType styleType;

  const LoginFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.styleType = TextStyleType.textFieldsInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextUtil.getTextStyle(styleType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyle,
        ),
        Container(
          height: 40,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: textStyle,
            decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/text_utils.dart';
import '../utils/colour_theme.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const LoginButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      required buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: TextUtil.getTextWidget(
        label,
        TextStyleType.loginButton,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorTheme.loginButtonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0),
      ),
    );
  }
}

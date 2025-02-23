import 'package:flutter/material.dart';
import '../utils/text_utils.dart';
import '../utils/colour_theme.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: TextUtil.getTextWidget(
        'Logout',
        TextStyleType.logoutButton,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorTheme.logoutButtonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0),
      ),
    );
  }
}

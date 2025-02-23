import 'package:flutter/material.dart';

class PopUpBox extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onClosed;

  PopUpBox({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onClosed != null) {
              onClosed!();
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

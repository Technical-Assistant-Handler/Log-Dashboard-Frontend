import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final logoWidth =
        screenSize.width * 0.175; // 17.5% of screen width for each logo
    final logoHeight = screenSize.height * 0.1; // 10% of screen height

    return Positioned(
      bottom: screenSize.height * 0.02, // 2% of screen height
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/APU Logo.png', // Replace with your APU logo asset path
            width: logoWidth,
            height: logoHeight,
          ),
          SizedBox(
              width: screenSize.width * 0.02), // 2% of screen width as spacing
          Image.asset(
            'assets/Apcore Logo.png', // Replace with your Apcore logo asset path
            width: logoWidth,
            height: logoHeight,
          ),
        ],
      ),
    );
  }
}

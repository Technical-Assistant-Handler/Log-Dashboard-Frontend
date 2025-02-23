import 'package:flutter/material.dart';
import '../utils/text_utils.dart';

class HeadingWidget extends StatelessWidget {
  final double topPadding;

  const HeadingWidget({Key? key, required this.topPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.05), // 5% of screen height
          TextUtil.getTextWidget(
            'Technical Assistant Attendance Log',
            TextStyleType.pageMainHeading,
          ),
          SizedBox(height: screenSize.height * 0.05), // 5% of screen height
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoggedInRow extends StatelessWidget {
  final int index;
  final Map<String, String> row;
  final bool isSelected;
  final VoidCallback onTap;

  const LoggedInRow({
    Key? key,
    required this.index,
    required this.row,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // TP Number column
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  row['TP Number'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            VerticalDivider(color: Colors.white),
            // Name column
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  row['Name'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            VerticalDivider(color: Colors.white),
            // Time column
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  row['Time'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

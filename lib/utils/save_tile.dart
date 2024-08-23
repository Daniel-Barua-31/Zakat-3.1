import 'package:flutter/material.dart';

class SaveTile extends StatelessWidget {
  final Map<String, dynamic> savedData;

  const SaveTile({super.key, required this.savedData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${savedData['date']}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Cash: ${savedData['cash']}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            // Add more fields here as needed
          ],
        ),
      ),
    );
  }
}

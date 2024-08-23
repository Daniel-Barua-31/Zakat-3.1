import 'package:flutter/material.dart';

class SavePage extends StatelessWidget {
  final List<Map<String, dynamic>> savedDataList;

  const SavePage({super.key, required this.savedDataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved Zakat Calculations",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
      ),
    );
  }
}

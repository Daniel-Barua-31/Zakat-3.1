// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AdvanceDonationPage extends StatefulWidget {
  const AdvanceDonationPage({
    super.key,
    required Map<String, dynamic> initialData,
    required int editIndex,
    required Null Function(dynamic updatedData) onSaveAdvanceDonation,
  });

  @override
  _AdvanceDonationPageState createState() => _AdvanceDonationPageState();
}

class _AdvanceDonationPageState extends State<AdvanceDonationPage> {
  String? dropdownValue;
  String? currencyValue;
  List<String> sessionYears = [];
  List<String> currencies = ['USD', 'BDT', 'EUR'];
  TextEditingController instituteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>> entries = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _generateSessionYears();
    currencyValue = currencies.first;
  }

  void _generateSessionYears() {
    final currentYear = DateTime.now().year;
    sessionYears.add('${currentYear - 1}-$currentYear');
    for (int i = 1; i <= 3; i++) {
      String session = '${currentYear + i - 1}-${currentYear + i}';
      sessionYears.add(session);
    }
    dropdownValue = sessionYears.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Advance Donation",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Future Session',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: dropdownValue,
                  items: sessionYears,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Currency',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  value: currencyValue,
                  items: currencies,
                  onChanged: (String? newValue) {
                    setState(() {
                      currencyValue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: instituteController,
                  decoration: InputDecoration(
                    labelText: 'Enter Institute Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Advance Donation Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Add Entry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Entries',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(entries[index]['institute']),
                      trailing:
                          Text('${entries[index]['amount']} $currencyValue'),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Amount: $totalAmount $currencyValue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveAdvanceDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Save Advance Donation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          underline: const SizedBox(),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(value),
              ),
            );
          }).toList(),
          isExpanded: true,
        ),
      ),
    );
  }

  void _addEntry() {
    if (instituteController.text.isNotEmpty &&
        amountController.text.isNotEmpty) {
      setState(() {
        double amount = double.parse(amountController.text);
        entries.add({
          'institute': instituteController.text,
          'amount': amount,
        });
        totalAmount += amount;
        instituteController.clear();
        amountController.clear();
      });
    }
  }

  void _saveAdvanceDonation() async {
    if (dropdownValue == null || entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select a session and add at least one entry.')),
      );
      return;
    }

    final advanceDonationData = {
      'sessionYear': dropdownValue,
      'currency': currencyValue,
      'totalAmount': totalAmount,
      'entries': entries,
      'date': DateTime.now().toString(),
    };

    final boxAdvanceDonation = await Hive.openBox('advanceDonation');
    await boxAdvanceDonation.add(advanceDonationData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Advance donation saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear the entries and total amount after saving
    setState(() {
      entries.clear();
      totalAmount = 0.0;
    });
  }

  @override
  void dispose() {
    instituteController.dispose();
    amountController.dispose();
    super.dispose();
  }
}

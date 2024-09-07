// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProcessPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSaveZakatProcess;
  final Map<String, dynamic>? initialZakatData;

  ProcessPage({
    Key? key,
    this.onSaveZakatProcess,
    this.initialZakatData,
  }) : super(key: key);

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  List<Map<String, dynamic>> zakatDataList = [];
  List<Map<String, dynamic>> entries = [];

  String dropdownValue = '2020-2021';
  bool changedButton = false;

  TextEditingController instituteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  double totalSpent = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialZakatData != null) {
      zakatDataList.add(widget.initialZakatData!);
      dropdownValue = widget.initialZakatData!['sessionYear'];
      totalSpent = widget.initialZakatData!['zakat'] -
          widget.initialZakatData!['remaining'];
      if (widget.initialZakatData!.containsKey('entries')) {
        entries = List<Map<String, dynamic>>.from(
            widget.initialZakatData!['entries']);
        for (var entry in entries) {
          totalSpent += entry['amount'];
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final zakatData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (zakatData != null && zakatDataList.isEmpty) {
      zakatDataList.add(zakatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Zakat",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Session',
              style: TextStyle(
                color: Colors.green[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  value: dropdownValue,
                  icon:
                      Icon(Icons.arrow_drop_down, color: Colors.green.shade700),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: [
                    '2020-2021',
                    '2021-2022',
                    '2022-2023',
                    '2023-2024',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: instituteController,
              decoration: InputDecoration(
                labelText: 'Enter Institute Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text("Add New Entry"),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entries[index]['institute'],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '\$${entries[index]['amount'].toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Donation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalSpent.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Zakat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_calculateTotalZakat().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining Zakat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_calculateRemainingZakat().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _zakatSave,
                  label: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  icon: Icon(Icons.save),
                  style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      backgroundColor: Colors.green[400],
                      padding: EdgeInsets.all(12)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _addEntry() {
    String institute = instituteController.text;
    double? amount = double.tryParse(amountController.text);

    if (institute.isNotEmpty && amount != null) {
      double totalZakat = _calculateTotalZakat();

      if (totalSpent + amount > totalZakat) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error: Total Spent Cannot exceed the total Zakat value'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          entries.add({'institute': institute, 'amount': amount});
          totalSpent += amount;
          instituteController.clear();
          amountController.clear();
        });
      }
    } else {
      // Handle invalid input (optional)
      print("Please enter valid data");
    }
  }

  double _calculateTotalZakat() {
    double totalZakat = 0.0;
    for (var zakatData in zakatDataList) {
      totalZakat += zakatData['zakat'];
    }
    return totalZakat;
  }

  double _calculateRemainingZakat() {
    return _calculateTotalZakat() - totalSpent;
  }

  void _zakatSave() {
    if (zakatDataList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No Zakat data available.')),
      );
      return;
    }

    var zakat = zakatDataList[0]['zakat'];
    var currency = zakatDataList[0]['currency'];
    var remaining = _calculateRemainingZakat();

    if (zakat == null || currency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Invalid Zakat data.')),
      );
      return;
    }

    final zakatProcessData = {
      'zakat': zakat,
      'currency': currency,
      'sessionYear': dropdownValue,
      'remaining': remaining,
      'entries': entries,
    };

    widget.onSaveZakatProcess!(zakatProcessData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Zakat data saved successfully!')),
    );
    Navigator.pop(context);
  }
}

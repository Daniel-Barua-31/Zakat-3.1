// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProcessPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSaveZakatProcess;
  final Map<String, dynamic>? initialZakatData;
  final int? editIndex;

  const ProcessPage({
    super.key,
    required this.onSaveZakatProcess,
    required this.initialZakatData,
    this.editIndex,
  });

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  List<Map<String, dynamic>> zakatDataList = [];
  List<Map<String, dynamic>> entries = [];
  List<String> availableSessionYears = [];

  String? dropdownValue;
  List<String> sessionYears = [];

  bool changedButton = false;

  TextEditingController instituteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  double totalSpent = 0.0;
  double advance = 0.0;
  double previousSessionAdvance = 0.0;
  double originalZakat = 0.0;
  double adjustedZakat = 0.0;
  double remainingZakat = 0.0;

  @override
  void initState() {
    super.initState();
    _generateSessionYears();
    _initializeData();
    // _checkPreviousSessionAdvance();
    _updateCalculations();
    _updateAvailableSessionYears();
  } // recent added! 10 PM

  void _generateSessionYears() {
    final currentYear = DateTime.now().year;
    for (int i = 0; i < 3; i++) {
      String session = '${currentYear - i - 1}-${currentYear - i}';
      sessionYears.add(session);
    }
    sessionYears.insert(0, '');
    dropdownValue = '';
  }

  void _updateAvailableSessionYears() {
    final boxZakatDistribution = Hive.box('zakatDistribution');
    Set<String> usedSessions = {};

    for (int i = 0; i < boxZakatDistribution.length; i++) {
      final data = boxZakatDistribution.getAt(i);
      if (data != null && data['sessionYear'] != null) {
        usedSessions.add(data['sessionYear']);
      }
    }

    availableSessionYears = sessionYears.where((session) {
      if (session.isEmpty) return true;
      if (widget.editIndex != null && session == dropdownValue) return true;
      return !usedSessions.contains(session);
    }).toList();

    if (dropdownValue == null || dropdownValue!.isEmpty) {
      dropdownValue = availableSessionYears.firstWhere((s) => s.isNotEmpty,
          orElse: () => '');
    }
  }

  void _initializeData() {
    if (widget.initialZakatData != null) {
      zakatDataList.add(Map<String, dynamic>.from(widget.initialZakatData!));
      dropdownValue = widget.initialZakatData!['sessionYear'] ?? '';
      totalSpent = 0.0;
      originalZakat = _calculateOriginalZakat();

      if (widget.editIndex != null) {
        _loadExistingData();
      } else {
        _loadInitialData();
      }
      _checkPreviousSessionAdvance();
      _updateCalculations();
    }
  } // recent added! 10 PM

  void _updateCalculations() {
    setState(() {
      originalZakat = _calculateOriginalZakat();
      adjustedZakat = originalZakat - previousSessionAdvance;
      remainingZakat = adjustedZakat - totalSpent;
      if (remainingZakat < 0) {
        advance = -remainingZakat;
        remainingZakat = 0;
      } else {
        advance = 0;
      }
    });
  }

  void _updateSessionData(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
      _checkPreviousSessionAdvance();
      _updateAdjustedZakat();
    });
  } // added now

  void _updateAdjustedZakat() {
    setState(() {
      double originalZakat = _calculateOriginalZakat();
      adjustedZakat = originalZakat - previousSessionAdvance;
      double remainingZakat = adjustedZakat - totalSpent;
      if (remainingZakat < 0) {
        advance = -remainingZakat;
      } else {
        advance = 0;
      }
    });
  }

  void _checkPreviousSessionAdvance() {
    if (dropdownValue != null && dropdownValue!.isNotEmpty) {
      final currentSessionYear = dropdownValue!.split('-')[0];
      final previousSessionYear =
          (int.parse(currentSessionYear) - 1).toString();
      final previousSession = '$previousSessionYear-$currentSessionYear';

      previousSessionAdvance = _getPreviousSessionAdvance(previousSession);
    } else {
      previousSessionAdvance = 0.0;
    }
  }

  double _getPreviousSessionAdvance(String previousSession) {
    final boxZakatDistribution = Hive.box('zakatDistribution');
    for (int i = 0; i < boxZakatDistribution.length; i++) {
      final data = boxZakatDistribution.getAt(i);
      if (data != null && data['sessionYear'] == previousSession) {
        return (data['advance'] as num?)?.toDouble() ?? 0.0;
      }
    }
    return 0.0;
  }

  void _loadExistingData() {
    final boxZakatDistribution = Hive.box('zakatDistribution');
    if (boxZakatDistribution.isNotEmpty &&
        widget.editIndex != null &&
        widget.editIndex! < boxZakatDistribution.length) {
      final existingData = boxZakatDistribution.getAt(widget.editIndex!);
      if (existingData != null && existingData is Map) {
        entries = (existingData['entries'] as List?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            [];
        for (var entry in entries) {
          totalSpent += (entry['amount'] as num?)?.toDouble() ?? 0.0;
        }
        dropdownValue = existingData['sessionYear'] ?? dropdownValue;
        advance = (existingData['advance'] as num?)?.toDouble() ?? 0.0;
      }
    }
  } // recent added! 10 PM

  void _loadInitialData() {
    if (widget.initialZakatData!.containsKey('entries')) {
      entries = (widget.initialZakatData!['entries'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [];
      for (var entry in entries) {
        totalSpent += (entry['amount'] as num?)?.toDouble() ?? 0.0;
      }
      advance =
          (widget.initialZakatData!['advance'] as num?)?.toDouble() ?? 0.0;
    }
  } // recent added! 10 PM

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
          "Donation Distribution",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                    child: widget.editIndex != null
                        ? Text(
                            dropdownValue ?? 'No session selected',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.green.shade700),
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                // dropdownValue = newValue!; // comment now
                                _updateSessionData(newValue);
                              });
                            },
                            items: availableSessionYears
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(value.isEmpty
                                      ? 'Select a session'
                                      : value),
                                ),
                              );
                            }).toList(),
                            hint: Text('Select a session'),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[200],
                  ),
                  child: Text(
                    "Add New Entry",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
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
                              '${entries[index]['amount'].toStringAsFixed(2)} ${_getCurrency()}',
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      // ignore: unnecessary_string_interpolations
                      '${totalSpent.toStringAsFixed(2)} ${_getCurrency()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Original Zakat',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${originalZakat.toStringAsFixed(2)} ${_getCurrency()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Previous Session Advance',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${previousSessionAdvance.toStringAsFixed(2)} ${_getCurrency()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adjusted Zakat ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${adjustedZakat.toStringAsFixed(2)} ${_getCurrency()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remaining Zakat',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${remainingZakat.toStringAsFixed(2)} ${_getCurrency()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Advance',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${advance.toStringAsFixed(2)} ${_getCurrency()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addEntry() {
    String institute = instituteController.text;
    double? amount = double.tryParse(amountController.text);

    if (institute.isNotEmpty && amount != null) {
      setState(() {
        entries.add({'institute': institute, 'amount': amount});
        totalSpent += amount;
        _updateCalculations();

        instituteController.clear();
        amountController.clear();
      });
    } else {
      print("Please enter valid data");
    }
  }

  double _calculateOriginalZakat() {
    double totalZakat = 0.0;
    for (var zakatData in zakatDataList) {
      totalZakat += zakatData['zakat'];
    }
    return totalZakat;
  }

  double _calculateAdjustedZakat() {
    return adjustedZakat;
  }

  double _calculateRemainingZakat() {
    return adjustedZakat - totalSpent;
  }

  String _getCurrency() {
    if (zakatDataList.isNotEmpty && zakatDataList[0].containsKey('currency')) {
      return zakatDataList[0]['currency'] ?? '';
    }
    return '';
  }

  double _displayRemainingZakat() {
    return _calculateRemainingZakat() > 0 ? _calculateRemainingZakat() : 0;
  }

  bool _isSessionUnique(String session) {
    final boxZakatDistribution = Hive.box('zakatDistribution');
    for (int i = 0; i < boxZakatDistribution.length; i++) {
      final data = boxZakatDistribution.getAt(i);
      if (data != null && data['sessionYear'] == session) {
        // If we're editing an existing entry, it's okay for it to match its own session
        if (widget.editIndex != null && i == widget.editIndex) {
          continue;
        }
        return false; // Session already exists
      }
    }
    return true; // Session is unique
  }

  void _zakatSave() {
    if (zakatDataList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No Zakat data available.')),
      );
      return;
    }

    var originalZakat = _calculateOriginalZakat();
    var adjustedZakat = _calculateAdjustedZakat();
    // var zakat = _calculateTotalZakat();
    var currency = zakatDataList[0]['currency'];
    var remaining = _calculateRemainingZakat();

    if (currency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Invalid Zakat data.')),
      );
      return;
    }

    if (!_isSessionUnique(dropdownValue!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error: Data for this session year has already been saved.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final zakatProcessData = {
      'zakat': originalZakat,
      'adjustedZakat': adjustedZakat,
      'currency': currency,
      'sessionYear': dropdownValue,
      // 'remaining': remaining,
      'remaining': _displayRemainingZakat(),
      'advance': advance,
      'previousSessionAdvance': previousSessionAdvance,
      'entries': entries,
      'date': DateTime.now().toString(),
    };

    final boxZakatDistribution = Hive.box('zakatDistribution');

    if (widget.editIndex != null) {
      boxZakatDistribution.putAt(
          widget.editIndex!, Map<String, dynamic>.from(zakatProcessData));
    } else {
      boxZakatDistribution.add(Map<String, dynamic>.from(zakatProcessData));
    }

    widget.onSaveZakatProcess?.call(zakatProcessData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Zakat data saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _debugPrintBox() {
    final boxZakat = Hive.box('boxZakat');
    print('Box Zakat data: ${boxZakat.values.toList()}');
  }
}

// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import '../utils/routes.dart';

class SelectCurrency extends StatefulWidget {
  const SelectCurrency({super.key});
  @override
  State<SelectCurrency> createState() => _SelectCurrencyState();
}

class _SelectCurrencyState extends State<SelectCurrency> {
  String dropdownValue = 'BDT';
  bool changedButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Currency',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200, // Set a fixed width for the dropdown
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
                    'BDT',
                    'USD',
                    'EUR',
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
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child: Material(
                  color: const Color.fromARGB(255, 236, 200, 81),
                  borderRadius: BorderRadius.circular(changedButton ? 60 : 12),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        changedButton = true;
                      });
                      await Future.delayed(
                        const Duration(seconds: 1),
                      );
                      Navigator.pushNamed(
                        context,
                        MyRoutes.MainRoute,
                        arguments: dropdownValue,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: changedButton ? 60 : 160,
                      height: 60,
                      alignment: Alignment.center,
                      child: changedButton
                          ? const Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            )
                          : const Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

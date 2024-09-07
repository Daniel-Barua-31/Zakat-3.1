// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

import '../utils/routes.dart';

class IntroPage extends StatefulWidget {
  IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool changedButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 150, left: 70),
              height: 250,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "ZAKAT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[400],
                    fontSize: 70,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 60),
              child: Material(
                color: Color.fromARGB(255, 236, 200, 81),
                borderRadius: BorderRadius.circular(changedButton ? 60 : 12),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      changedButton = true;
                    });
                    await Future.delayed(
                      Duration(seconds: 1),
                    );
                    Navigator.pushNamed(context, MyRoutes.SelectedRoute);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: changedButton ? 60 : 160,
                    height: 60,
                    alignment: Alignment.center,
                    child: changedButton
                        ? Icon(
                            Icons.calculate,
                            color: Colors.white,
                          )
                        : Text(
                            "Calculate",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

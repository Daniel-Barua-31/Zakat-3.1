// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../utils/routes.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool changedButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 250,
                      maxHeight: 250,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.all(20),
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
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Material(
                  color: Color.fromARGB(255, 236, 200, 81),
                  borderRadius: BorderRadius.circular(changedButton ? 60 : 12),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        changedButton = true;
                      });
                      await Future.delayed(Duration(seconds: 1));
                      Navigator.pushNamed(context, MyRoutes.SelectedRoute);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: changedButton ? 60 : 160,
                      height: 60,
                      alignment: Alignment.center,
                      child: changedButton
                          ? Icon(Icons.calculate, color: Colors.white)
                          : Text(
                              "Calculate",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

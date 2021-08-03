import 'dart:async';

import 'package:flutter/material.dart';

import 'bask_home_screen.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {


  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BaskHomeScreen(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // SizedBox(height: 100),
          Image.asset("assets/images/food-animation.gif"),
          Text(
            "BASK",
            style: TextStyle(
              fontSize: 100,
              color: Colors.lightBlue[300],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

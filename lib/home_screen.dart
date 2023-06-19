import 'dart:async';

import 'package:flutter/material.dart';

import 'animated_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(seconds: 15),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AnimationPage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/solar.gif',
          fit: BoxFit.fitHeight,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

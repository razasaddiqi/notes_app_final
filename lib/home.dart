// import 'dart:async';
import 'package:flutter/material.dart';
class home_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
            child: home_page()
          // Padding(
          //   // padding: EdgeInsets.symmetric(horizontal: 10.0),
          //   child: QuizPage(),
          // ),
        ),
      ),
    );
  }
}

class home_page extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<home_page>  {

  @override
  Widget build(BuildContext context) {
    // quizBrain.shuffle();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("hello")
      ],
    );
  }
}
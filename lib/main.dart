import 'package:bottlebucks/TransactionHistory.dart';
import 'package:bottlebucks/about.dart';
import 'package:bottlebucks/banktransaction.dart';
import 'package:bottlebucks/home.dart';
import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/profileview.dart';
import 'package:bottlebucks/redeemgift.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Loginscreen(),
    );
  }
}

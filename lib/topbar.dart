import 'package:bottlebucks/TransactionHistory.dart';
import 'package:bottlebucks/redeemhistory.dart';
import 'package:flutter/material.dart';

class Bottombarpage extends StatefulWidget {
  const Bottombarpage({super.key});

  @override
  State<Bottombarpage> createState() => _BottombarpageState();
}

class _BottombarpageState extends State<Bottombarpage> {
  int _currentIndex = 0;

  // Add your two pages here
  final List<Widget> _pages = [
    BankTransactionHistoryPage(), // PAGE 1
    RedeemHistoryPage(), // PAGE 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display selected page

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Redeem History",
          ),
        ],
      ),
    );
  }
}

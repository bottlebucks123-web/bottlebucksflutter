import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/register.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// 🔹 Replace with your actual values

//////////////////////////////////////////////////
// MODEL
//////////////////////////////////////////////////
class TransactionModel {
  final int points;
  final double money;
  final DateTime dateTime;

  TransactionModel({
    required this.points,
    required this.money,
    required this.dateTime,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      points: json['points'],
      money: (json['redeemmoney'] as num).toDouble(),
      dateTime: DateTime.parse(json['date']),
    );
  }
}

//////////////////////////////////////////////////
// MAIN SCREEN
//////////////////////////////////////////////////
class BankTransactionHistoryPage extends StatefulWidget {
  const BankTransactionHistoryPage({super.key});

  @override
  State<BankTransactionHistoryPage> createState() =>
      _BankTransactionHistoryPageState();
}

class _BankTransactionHistoryPageState
    extends State<BankTransactionHistoryPage> {
  List<TransactionModel> transactionHistory = [];
  bool isLoading = true;

  Future<void> transactionHistoryAPIGet() async {
    try {
      final response = await dio.get('$base_url/TransactionHistoryAPI/$LID');
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          transactionHistory = (response.data as List)
              .map((e) => TransactionModel.fromJson(e))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    transactionHistoryAPIGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Transaction History"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : transactionHistory.isEmpty
            ? const Center(child: Text("No Transactions Found"))
            : ListView.builder(
                itemCount: transactionHistory.length,
                itemBuilder: (context, index) {
                  final tx = transactionHistory[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.monetization_on,
                          color: Colors.blue,
                        ),
                      ),
                      title: Text(
                        "₹ ${tx.money}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Points: ${tx.points}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${tx.dateTime.day}-${tx.dateTime.month}-${tx.dateTime.year} "
                            "${tx.dateTime.hour}:${tx.dateTime.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

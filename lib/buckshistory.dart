import 'package:bottlebucks/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'register.dart';

List<dynamic> PointHistory = [];

class PointHistoryTablePage extends StatefulWidget {
  const PointHistoryTablePage({super.key});

  @override
  State<PointHistoryTablePage> createState() => _PointHistoryTablePageState();
}

class _PointHistoryTablePageState extends State<PointHistoryTablePage> {
  @override
  Widget build(BuildContext context) {
    Future<void> BucksHistoryAPI_get(context) async {
      try {
        final Response = await dio.get('$base_url/BucksHistoryAPI/$LID');
        print(Response.data);
        if (Response.statusCode == 200 || Response.statusCode == 201) {
          setState(() {
            PointHistory = Response.data;
          });
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Point Credit History"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Point History",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ MODERN CARD LIST (NOT TABLE)
            Expanded(
              child: ListView.builder(
                itemCount: PointHistory.length,
                itemBuilder: (context, index) {
                  final item = PointHistory[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        // ⭐ Left Icon Circle
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade300,
                                Colors.green.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        // ⭐ Middle Text Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "${item["date"]} • ${item["time"]}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ⭐ Right Side Bucks
                        Text(
                          "+${item["points"]}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

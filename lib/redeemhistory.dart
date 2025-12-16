import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/mykyc.dart';
import 'package:bottlebucks/register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

List<dynamic> History = [];
Dio dio = Dio();

class RedeemHistoryPage extends StatefulWidget {
  const RedeemHistoryPage({super.key});

  @override
  State<RedeemHistoryPage> createState() => _RedeemHistoryPageState();
}

class _RedeemHistoryPageState extends State<RedeemHistoryPage> {
  Future<void> RedeemHistoryAPI_get(context) async {
    try {
      final Response = await dio.get('$base_url/RedeemHistoryAPI/$LID');
      print(Response.data);
      if (Response.statusCode == 200 || Response.statusCode == 201) {
        setState(() {
          History = Response.data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // ⭐ Sample Redeem History Data
  // ⭐ Example Summary Values
  final int totalBucks = 3000;

  final int redeemedBucks = 1650;
  @override
  void initState() {
    RedeemHistoryAPI_get(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int balanceBucks = totalBucks - redeemedBucks;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Redeem History"),
        backgroundColor: Colors.deepPurple,
      ),

      body: History.isEmpty
          ? const Center(child: CircularProgressIndicator())
          :
            // ⭐ MODERN CARD-BASED LIST
            Expanded(
              child: ListView.builder(
                itemCount: History.length,
                itemBuilder: (context, index) {
                  final item = History[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ⭐ Left Side Icon
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade300,
                                Colors.red.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        // ⭐ Middle Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(base_url + item["product_image"]),
                              const SizedBox(height: 4),
                              Text(
                                item["product_name"],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${item["date"]}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ⭐ Right Side Bucks Used
                        Text(
                          "-${item["totalRewardSpend"]}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  // ⭐ Circular Stats UI
  Widget _buildCircleStat(String title, int value, Color color) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

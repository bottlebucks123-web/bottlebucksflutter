import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/register.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyKycPage extends StatefulWidget {
  const MyKycPage({super.key});

  @override
  State<MyKycPage> createState() => _MyKycPageState();
}

List<dynamic> Result = [];
Dio dio = Dio();

class _MyKycPageState extends State<MyKycPage> {
  Future<void> KycAPI_get(Context) async {
    try {
      final response = await dio.get('$base_url/KycAPI/$LID');
      print("+++++++++++++++++++,${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          Result = response.data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteKyc(int kycId) async {
    try {
      final response = await dio.delete('$base_url/KycAPI/$kycId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("KYC deleted successfully")),
        );

        // Refresh list
        KycAPI_get(context);
      }
    } catch (e) {
      print("Delete Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete KYC")));
    }
  }

  @override
  void initState() {
    super.initState();
    KycAPI_get(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("My KYC Details"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),

      body: Result.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: Result.length,
              itemBuilder: (context, index) {
                final item = Result[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KYC Entry ${index + 1}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),

                      buildKycRow(
                        Icons.person,
                        "Name",
                        item["Name"].toString(),
                        onDelete: () {
                          _confirmDelete(item["id"]);
                        },
                      ),

                      const SizedBox(height: 10),
                      buildKycRow(
                        Icons.person,
                        "BANK Name",
                        item["Bankname"].toString(),
                      ),
                      const SizedBox(height: 10),

                      // buildKycRow(
                      //   Icons.person,
                      //   "BANK Name",
                      //   item["Bankname"].toString(),
                      // ),
                      // const SizedBox(height: 10),
                      buildKycRow(
                        Icons.account_balance,
                        "BANK ACC",
                        item["ACno"].toString(),
                      ),
                      const SizedBox(height: 10),

                      buildKycRow(
                        Icons.account_balance_wallet,
                        "IFSC",
                        item["IFSCcode"],
                      ),
                      const SizedBox(height: 10),

                      buildKycRow(Icons.payment, "UPI", item["UPI"] ?? "N/A"),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(int kycId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete KYC"),
        content: const Text("Are you sure you want to delete this KYC entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deleteKyc(kycId);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  /// KYC Row Widget
  Widget buildKycRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onDelete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.green, size: 26),
        const SizedBox(width: 12),

        SizedBox(
          width: 110,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),

        // --------------------------
        // DELETE BUTTON CONTAINER
        // --------------------------
        if (onDelete != null) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// import 'package:bottlebucks/login.dart';
// import 'package:bottlebucks/register.dart';
// import 'package:flutter/material.dart';

// class BankTransactionPage extends StatefulWidget {
//   const BankTransactionPage({super.key});

//   @override
//   State<BankTransactionPage> createState() => _BankTransactionPageState();
// }

// class _BankTransactionPageState extends State<BankTransactionPage> {
//   Map<String, dynamic>? userData;
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBankProfile();
//   }

//   // Mask account number except last 4 digits
//   String maskAccountNumber(String number) {
//     if (number.length < 4) return number;
//     return "*" * (number.length - 4) + number.substring(number.length - 4);
//   }

//   // ------------------ FETCH PROFILE API --------------------
//   Future<void> fetchBankProfile() async {
//     try {
//       var response = await dio.get("$base_url/profile/$LID");

//       print(response.data);

//       setState(() {
//         userData = response.data[0]; // picking FIRST user object
//         loading = false;
//       });
//     } catch (e) {
//       print("Profile Fetch Error: $e");
//       setState(() => loading = false);
//     }
//   }

//   // ------------------ REDEEM API --------------------
//   Future<void> redeemPoints(int points) async {
//     try {
//       var response = await dio.post(
//         "$base_url/CreditPointsAPI/",
//         data: {
//           "account_id": userData!["id"].toString(), // pass ID
//           "points": points.toString(),
//           "user_id": LID, // pass Points
//         },
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Redeemed $points points successfully!")),
//       );
//     } catch (e) {
//       print("Redeem Error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Redeem failed!")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (userData == null) {
//       return const Scaffold(body: Center(child: Text("No Data Found")));
//     }

//     String maskedAC = maskAccountNumber(userData!["ACno"].toString());

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("Bank Transaction"),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Colors.deepPurple,
//         child: const Icon(Icons.add),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: Column(
//             children: [
//               // ---------------- USER DETAILS BOX -------------------
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Name: ${userData!["user_name"]}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),

//                     Text(
//                       "Account Number: $maskedAC",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 6),

//                     Text(
//                       "UPI ID: ${userData!["UPI"]}",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 6),

//                     Text(
//                       "Available Points: ${userData!["user_point"]}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               const Text(
//                 "Convert Points to Money",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 20),

//               redeemBox("10 Points = ₹1", 10, 1),
//               const SizedBox(height: 15),

//               redeemBox("100 Points = ₹10", 100, 10),
//               const SizedBox(height: 15),

//               redeemBox("1000 Points = ₹100", 1000, 100),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ------------------- REUSABLE REDEEM BOX ----------------------
//   Widget redeemBox(String title, int points, int money) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),

//           Row(
//             children: [
//               Icon(Icons.stars, color: Colors.amber[700], size: 28),
//               const SizedBox(width: 8),
//               Text(
//                 "$points Points  →  ₹$money",
//                 style: const TextStyle(fontSize: 17),
//               ),
//             ],
//           ),

//           const SizedBox(height: 15),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 redeemPoints(points); // calling API
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 "Redeem",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/register.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BankTransactionPage extends StatefulWidget {
  const BankTransactionPage({super.key});

  @override
  State<BankTransactionPage> createState() => _BankTransactionPageState();
}

class _BankTransactionPageState extends State<BankTransactionPage> {
  List<dynamic> accounts = [];
  bool loading = true;

  int selectedIndex = 0; // default selected account

  @override
  void initState() {
    super.initState();
    fetchBankProfile();
  }

  // Mask account number except last 4 digits
  String maskAccountNumber(String number) {
    if (number.length < 4) return number;
    return "*" * (number.length - 4) + number.substring(number.length - 4);
  }

  // ------------------ FETCH USER ACCOUNTS --------------------
  Future<void> fetchBankProfile() async {
    try {
      var response = await dio.get("$base_url/profile/$LID");

      print(response.data);

      setState(() {
        accounts = response.data; // ALL KYC ACCOUNTS
        loading = false;
      });
    } catch (e) {
      print("Profile Fetch Error: $e");
      setState(() => loading = false);
    }
  }

  // ------------------ REDEEM POINTS API --------------------
  Future<void> redeemPoints(int points) async {
    try {
      var selectedAcc = accounts[selectedIndex];

      var response = await dio.post(
        "$base_url/CreditPointsAPI/",
        data: {
          "account_id": selectedAcc["id"].toString(),
          "points": points.toString(),
          "user_id": LID,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Redeemed $points points successfully!")),
      );
    } catch (e) {
      print("Redeem Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Redeem failed!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (accounts.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Accounts Found")));
    }

    var userData = accounts[selectedIndex];
    String maskedAC = maskAccountNumber(userData["ACno"].toString());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Bank Transaction"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // ---- ACCOUNT SWITCH DROPDOWN ----
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: DropdownButton<int>(
                  value: selectedIndex,
                  isExpanded: true,
                  underline: const SizedBox(),
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value!;
                    });
                  },
                  items: List.generate(accounts.length, (index) {
                    final acc = accounts[index];
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        "${maskAccountNumber(acc["ACno"].toString())} • ${acc["Bankname"]}",
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- USER DETAILS BOX -------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${userData["Name"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Account Number: $maskedAC",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "UPI ID: ${userData["UPI"]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Available Points: ${userData["user_point"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Convert Points to Money",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              redeemBox("10 Points = ₹1", 10, 1),
              const SizedBox(height: 15),

              redeemBox("100 Points = ₹10", 100, 10),
              const SizedBox(height: 15),

              redeemBox("1000 Points = ₹100", 1000, 100),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- REUSABLE REDEEM BOX ----------------------
  Widget redeemBox(String title, int points, int money) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.stars, color: Colors.amber[700], size: 28),
              const SizedBox(width: 8),
              Text(
                "$points Points  →  ₹$money",
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                redeemPoints(points);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Redeem",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

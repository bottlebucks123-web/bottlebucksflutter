// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// // Replace these with your actual imports / constants
// import 'package:bottlebucks/login.dart';
// import 'package:bottlebucks/register.dart';

// class RedeemGiftPage extends StatefulWidget {
//   const RedeemGiftPage({super.key});

//   @override
//   State<RedeemGiftPage> createState() => _RedeemGiftPageState();
// }

// class _RedeemGiftPageState extends State<RedeemGiftPage> {
//   List<dynamic> profileList = [];
//   List<dynamic> giftItems = [];
//   bool loading = true;
//   int selectedAccountIndex = 0;
//   int? points;

//   final String getGiftsUrl = "$base_url/ProductAPI";
//   final String redeemUrl = "$base_url/RedeemGiftAPI";

//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }

//   // ---------------- FETCH PROFILE ----------------
//   Future<void> fetchProfile() async {
//     try {
//       final res = await dio.get("$base_url/profile/$LID");
//       print("PROFILE DATA: ${res.data}");

//       if (res.data is List && res.data.isNotEmpty) {
//         setState(() {
//           profileList = res.data;
//           points = profileList[selectedAccountIndex]['user_point'];
//         });
//         fetchGifts(); // Fetch gifts after profile
//       } else {
//         setState(() => loading = false);
//       }
//     } catch (e) {
//       print("PROFILE FETCH ERROR: $e");
//       setState(() => loading = false);
//     }
//   }

//   // ---------------- FETCH GIFTS ----------------
//   Future<void> fetchGifts() async {
//     try {
//       final response = await dio.get(getGiftsUrl);
//       print("GIFTS DATA: ${response.data}");

//       if (response.statusCode == 200) {
//         setState(() {
//           // Filter gifts based on points & quantity
//           giftItems = response.data
//               .where(
//                 (item) =>
//                     (item["PointsEligible"] ?? 0) <= (points ?? 0) &&
//                     (item["Quantity"] ?? 0) > 0,
//               )
//               .toList();
//           loading = false;
//         });
//       } else {
//         throw Exception("Failed to load gifts");
//       }
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to load gifts: $e")));
//     }
//   }

//   // ---------------- REDEEM GIFT ----------------
//   Future<void> redeemGift(String giftId) async {
//     try {
//       final response = await dio.post("$redeemUrl/$LID/$giftId");

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Gift redeemed successfully!")),
//         );
//         fetchProfile(); // Refresh points & gifts
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Redeem failed!")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(color: Colors.deepPurple),
//         ),
//       );
//     }

//     if (profileList.isEmpty) {
//       return const Scaffold(body: Center(child: Text("No profile data found")));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Redeem Gift"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       backgroundColor: Colors.grey[100],
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // ---------------- ACCOUNT SELECTOR ----------------
//             // Row(
//             //   children: [
//             //     const Text(
//             //       "Select Account: ",
//             //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             //     ),
//             //     const SizedBox(width: 12),
//             //     DropdownButton<int>(
//             //       value: selectedAccountIndex,
//             //       items: List.generate(profileList.length, (index) {
//             //         final user = profileList[index];
//             //         return DropdownMenuItem(
//             //           value: index,
//             //           child: Text(
//             //             "${user['Bankname']} (${user['ACno'].toString().substring(user['ACno'].toString().length - 4)})",
//             //           ),
//             //         );
//             //       }),
//             //       onChanged: (value) {
//             //         if (value != null) {
//             //           setState(() {
//             //             selectedAccountIndex = value;
//             //             points =
//             //                 profileList[selectedAccountIndex]['user_point'];
//             //             loading = true;
//             //           });
//             //           fetchGifts(); // Refetch gifts for selected account
//             //         }
//             //       },
//             //     ),
//             //   ],
//             // ),
//             const SizedBox(height: 20),

//             // ---------------- USER POINTS ----------------
//             Text(
//               "Available Points: $points",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple,
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ---------------- GIFT LIST ----------------
//             giftItems.isEmpty
//                 ? const Text(
//                     "No gifts available for your points",
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   )
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: giftItems.length,
//                     itemBuilder: (context, index) {
//                       final item = giftItems[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 6,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // ---------------- IMAGE ----------------
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ImageZoomPage(
//                                       imageUrl: base_url + item["ProductImage"],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.network(
//                                   base_url + item["ProductImage"],
//                                   height: 160,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // ---------------- NAME ----------------
//                             Text(
//                               item["ProductName"],
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),

//                             // ---------------- DESCRIPTION ----------------
//                             Text(
//                               item["Description"],
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // ---------------- POINTS ----------------
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.stars,
//                                   color: Colors.amber,
//                                   size: 22,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   "Eligible Points: ${item['PointsEligible']}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 15),

//                             // ---------------- REDEEM BUTTON ----------------
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed:
//                                     points! >= (item['PointsEligible'] ?? 0)
//                                     ? () {
//                                         showDialog(
//                                           context: context,
//                                           builder: (_) => AlertDialog(
//                                             title: const Text(
//                                               "Redeem Confirmation",
//                                             ),
//                                             content: Text(
//                                               "Do you want to redeem '${item["ProductName"]}' for ${item["PointsEligible"]} points?",
//                                             ),
//                                             actions: [
//                                               TextButton(
//                                                 child: const Text("Cancel"),
//                                                 onPressed: () =>
//                                                     Navigator.pop(context),
//                                               ),
//                                               ElevatedButton(
//                                                 child: const Text("Redeem"),
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                   redeemGift(
//                                                     item["id"].toString(),
//                                                   );
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       points! >= (item['PointsEligible'] ?? 0)
//                                       ? Colors.deepPurple
//                                       : Colors.grey,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Redeem Now",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ---------------- IMAGE ZOOM ----------------
// class ImageZoomPage extends StatelessWidget {
//   final String imageUrl;
//   const ImageZoomPage({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text("Zoom Image"),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 1,
//           maxScale: 5,
//           child: Image.network(imageUrl),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Your existing imports
import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/register.dart';

class RedeemGiftPage extends StatefulWidget {
  const RedeemGiftPage({super.key});

  @override
  State<RedeemGiftPage> createState() => _RedeemGiftPageState();
}

class _RedeemGiftPageState extends State<RedeemGiftPage> {
  List<dynamic> profileList = [];
  List<dynamic> giftItems = [];

  bool loading = true;
  int selectedAccountIndex = 0;
  int? points;
  bool isEditingAddress = false;

  TextEditingController addressController = TextEditingController();

  final String getGiftsUrl = "$base_url/ProductAPI";
  final String redeemUrl = "$base_url/RedeemGiftAPI";
  final String updateAddressUrl = "$base_url/UpdateAddressAPI";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  // ---------------- FETCH PROFILE ----------------
  Future<void> fetchProfile() async {
    try {
      final res = await dio.get("$base_url/ProfileViewAPI/$LID");
      print("PROFILE DATA: ${res.data}");

      if (res.data is List && res.data.isNotEmpty) {
        setState(() {
          profileList = res.data;
          points = profileList[selectedAccountIndex]['point'];
          addressController.text =
              profileList[selectedAccountIndex]['Address'] ?? "";
        });
        fetchGifts();
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
      debugPrint("PROFILE FETCH ERROR: $e");
    }
  }

  // ---------------- FETCH GIFTS ----------------
  Future<void> fetchGifts() async {
    try {
      final response = await dio.get(getGiftsUrl);
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          giftItems = response.data
              .where(
                (item) =>
                    (item["PointsEligible"] ?? 0) <= (points ?? 0) &&
                    (item["Quantity"] ?? 0) > 0,
              )
              .toList();
          loading = false;
        });
      } else {
        throw Exception("Gift fetch failed");
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load gifts: $e")));
    }
  }

  // ---------------- REDEEM GIFT ----------------
  Future<void> redeemGift(String giftId) async {
    try {
      final response = await dio.post(
        "$redeemUrl/$LID/$giftId",
        data: {
          "address": addressController.text, // ✅ correct
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gift redeemed successfully")),
        );
        fetchProfile();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Redeem error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Redeem Gift"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= ADDRESS SECTION =================
            // ================= ADDRESS SECTION =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditingAddress = !isEditingAddress;
                          });
                        },
                        child: Text(isEditingAddress ? "Cancel" : "Change"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // -------- ADDRESS VIEW / EDIT --------
                  isEditingAddress
                      ? TextField(
                          controller: addressController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: "Enter delivery address",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                addressController.text.isEmpty
                                    ? "No address available"
                                    : addressController.text,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),

                  // -------- SAVE BUTTON --------
                  if (isEditingAddress) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isEditingAddress = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= POINTS =================
            Text(
              "Available Points: $points",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

            // ================= GIFTS =================
            giftItems.isEmpty
                ? const Text("No gifts available")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: giftItems.length,
                    itemBuilder: (context, index) {
                      final item = giftItems[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             InkWell(
  onTap: () {
    _showZoomImage(
      context,
      base_url + item["ProductImage"],
    );
  },
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      base_url + item["ProductImage"],
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  ),
),

                              const SizedBox(height: 12),
                              Text(
                                item["ProductName"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(item["Description"]),
                              const SizedBox(height: 12),
                              Text(
                                "Points: ${item['PointsEligible']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: points! >= item['PointsEligible']
                                      ? () => redeemGift(item['id'].toString())
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text(
                                    "Redeem Now",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
void _showZoomImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (_) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: Image.network(imageUrl),
            ),
          ),
        ),
      );
    },
  );
}

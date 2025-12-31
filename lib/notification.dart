// import 'package:bottlebucks/register.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   List<dynamic> notifications = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   Future<void> fetchNotifications() async {
//     try {
//       final response = await Dio().get('$base_url/NotificationApi');
//       print(response.data);
//       if (response.statusCode == 200) {
//         setState(() {
//           notifications = response.data;
//           isLoading = false;
//         });
//       } else {
//         print('Failed to fetch notifications');
//       }
//     } catch (e) {
//       print('Error fetching notifications: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : notifications.isEmpty
//           ? const Center(child: Text("No notifications available"))
//           : ListView.builder(
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = notifications[index];
//                 return Card(
//                   elevation: 3,
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(10),
//                     leading: notification['Image'] != null
//                         ? Image.network(
//                             '$base_url${notification['Image']}',
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                           )
//                         : Container(
//                             width: 60,
//                             height: 60,
//                             color: Colors.grey.shade300,
//                             child: const Icon(
//                               Icons.notifications,
//                               color: Colors.white,
//                             ),
//                           ),
//                     title: Text(
//                       notification['Description'] ?? "",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/register.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllNotifications();
  }

  // ---------------- FETCH BOTH APIs ----------------
  Future<void> fetchAllNotifications() async {
    setState(() => isLoading = true);

    try {
      final responses = await Future.wait([
        dio.get('$base_url/NotificationApi'), // First API
        dio.get('$base_url/UserNotificationApi/$LID'), // Second API
      ]);

      final firstApiData = responses[0].data;
      final secondApiData = responses[1].data;

      setState(() {
        notifications = [...firstApiData, ...secondApiData];
        isLoading = false;
      });

      print('Merged Notifications: $notifications');
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("No notifications available"))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: notification['Image'] != null
                            ? Image.network(
                                '$base_url${notification['Image']}',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                              ),
                        title: Text(
                          notification['Description'] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(notification['source'] ?? ''),
                      ),
                    );
                  },
                ),
    );
  }
}

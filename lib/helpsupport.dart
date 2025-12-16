import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Page Title
            const Center(
              child: Text(
                "How Can We Help You?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Intro
            const Text(
              "BottleBucks is designed to help users recycle plastic bottles using a smart reward-based system. "
              "If you face any issues while using the application, the following information will guide you.",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            /// FAQs
            sectionTitle("Frequently Asked Questions"),

            helpItem(
              "How do I register in BottleBucks?",
              "Users can register by providing basic details in the registration page and wait for admin approval.",
            ),

            helpItem(
              "How do I use the QR code?",
              "After admin approval, a QR code will be provided. Scan the QR code using the app to access the system.",
            ),

            helpItem(
              "How are rewards provided?",
              "Rewards are credited to the user account after successful bottle disposal using the smart machine.",
            ),

            helpItem(
              "What if my reward is not updated?",
              "Please wait for some time as rewards are verified by the admin. Contact support if the issue continues.",
            ),

            const SizedBox(height: 20),

            /// Contact Support
            sectionTitle("Contact Support"),

            const Text(
              "If you need further assistance, please contact our support team:",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'support@bottlebucks.com',
                  query: 'subject=Support%20Request', // optional
                );

                // Use launchUrl instead of canLaunchUrl + launch
                try {
                  await launchUrl(
                    emailLaunchUri,
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email app')),
                  );
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.email, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "support@bottlebucks.com",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: const [
                Icon(Icons.phone, color: Colors.green),
                SizedBox(width: 8),
                Text("+91 98765 43210"),
              ],
            ),

            const SizedBox(height: 30),

            /// Footer
            const Center(
              child: Text(
                "We are happy to help you recycle responsibly!",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Title Widget
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  /// Help Item Widget
  Widget helpItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

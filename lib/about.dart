import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// App Title
            const Text(
              "About",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 15),

            /// Description
            const Text(
              "BottleBucks is an eco-friendly software application designed to encourage responsible plastic bottle disposal. "
              "By integrating smart technology such as QR code scanning and reward systems, BottleBucks motivates users to recycle plastic bottles effectively.\n\n"
              "The goal of this project is to reduce plastic pollution, promote environmental awareness, and reward users for adopting sustainable practices. "
              "BottleBucks bridges the gap between technology and environmental responsibility by making recycling engaging and rewarding.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            /// Footer
            const Text(
              "© 2025 BottleBucks Project",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

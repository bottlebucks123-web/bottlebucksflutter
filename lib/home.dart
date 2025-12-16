import 'dart:async';

import 'package:bottlebucks/Rewards.dart';
import 'package:bottlebucks/about.dart';
import 'package:bottlebucks/banktransaction.dart';
import 'package:bottlebucks/buckshistory.dart';
import 'package:bottlebucks/helpsupport.dart';
import 'package:bottlebucks/kyc.dart';
import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/notification.dart';
import 'package:bottlebucks/profileview.dart';
import 'package:bottlebucks/redeemgift.dart';
import 'package:bottlebucks/redeemhistory.dart';
import 'package:bottlebucks/register.dart' hide dio;
import 'package:bottlebucks/topbar.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  final List<String> _carouselImages = [
    'assets/images/pic2.jpg',
    'assets/images/images3.jpg',
    'assets/images/haritha-karma-sena.webp',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',

  ];

  // -------------------------
  // USER PROFILE VARIABLES
  // -------------------------
  String name = "";
  int points = 0;
  String email = "";
  String profileImage = "";
  String qr = '';
  bool loading = true;late Timer _timer;
int _currentPage = 0;


 @override
void initState() {
  super.initState();
  fetchProfile();
  _startAutoScroll();
}
void _startAutoScroll() {
  _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    if (_pageController.hasClients) {
      _currentPage++;

      if (_currentPage >= _carouselImages.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  });
}
@override
void dispose() {
  _timer.cancel();
  _pageController.dispose();
  super.dispose();
}


  // FETCH PROFILE FROM API
  Future<void> fetchProfile() async {
    try {
      final res = await dio.get("$base_url/ProfileViewAPI/$LID");
      print("+++++++++++,${res.data}");

      if (res.data is List && res.data.isNotEmpty) {
        final firstUser = res.data[0]; // take the first user
        setState(() {
          name = firstUser["Name"] ?? "Unknown";
          points =
              int.tryParse(firstUser["point"].toString()) ?? 0; // <-- ADD THIS
          email = firstUser["Email"] ?? "No Email"; // if your API has 'email'
          profileImage = firstUser["Image"] ?? "";
          qr = firstUser['qr'];
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("PROFILE FETCH ERROR: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------
      appBar: AppBar(
        title: const Text(
          'Bottle Bucks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            icon: const Icon(Icons.notification_add),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$value selected')));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                ),
                value: 'Profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpSupportPage()),
                  );
                },
                value: 'Help & Support',
                child: Row(
                  children: [
                    Icon(Icons.help_center_outlined, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text('Help & Support'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
                value: 'About Us',
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(Icons.info_outlined, color: Colors.black),
                    Text('About Us'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Loginscreen()),
                  (route) => false,
                ),
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),

                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // ------------------------------------------------------------
      // DRAWER
      // ------------------------------------------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                loading ? "Loading..." : (name.isEmpty ? "Unknown User" : name),
              ),
              accountEmail: Text(email.isEmpty ? "No Email" : email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(base_url + profileImage)
                    : null,
                child: profileImage.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.black)
                    : null,
              ),
              decoration: const BoxDecoration(color: Colors.yellow),
            ),

            // QR CODE
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'My QR Code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.network('$base_url$qr', width: 120, height: 120),
                ],
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      // ------------------------------------------------------------
      // BODY
      // ------------------------------------------------------------
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CAROUSEL SLIDER
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child:PageView.builder(
  controller: _pageController,
  itemCount: _carouselImages.length,
  onPageChanged: (index) {
    _currentPage = index;
  },
  itemBuilder: (context, index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        _carouselImages[index],
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  },
),

                  ),
                  const SizedBox(height: 12),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _carouselImages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                ],
              ),
            ),

            // WELCOME USER + MY BUCKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        loading ? "Welcome..." : "Welcome $name!",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  RoundOptionCard(
                    // icon: Icons.stars_outlined,
                    label: 'My Bucks',
                    color: Colors.purple,
                    points: points, // <-- NEW PARAM
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------------------
            //       YOUR EXISTING CARDS (UNCHANGED)
            // ------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Scan + Bucks History
                  Row(
                    children: [
                      Expanded(
                        child: HomeOptionCard(
                          icon: Icons.qr_code_scanner_outlined,
                          title: 'Scan QR Code',
                          color: Colors.blueAccent,
                          size: HomeCardSize.large,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: HomeOptionCard(
                          icon: Icons.star_border_purple500_outlined,
                          title: 'Bucks History',
                          color: Colors.green,
                          size: HomeCardSize.large,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PointHistoryTablePage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rewards
                  Row(
                    children: [
                      Expanded(
                        child: HomeOptionCard(
                          icon: Icons.diamond_outlined,
                          title: 'Rewards',
                          color: const Color.fromRGBO(65, 4, 112, 1),
                          size: HomeCardSize.medium,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RewardPage(bucks: points),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Redeem Gift + Redeem History
                  Row(
                    children: [
                      Expanded(
                        child: HomeOptionCard(
                          icon: Icons.wallet_giftcard_rounded,
                          title: 'Redeem Gift',
                          color: Colors.green,
                          size: HomeCardSize.medium,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RedeemGiftPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: HomeOptionCard(
                          icon: Icons.history,
                          title: 'Redeem History',
                          color: Colors.orange,
                          size: HomeCardSize.medium,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Bottombarpage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // KYC + Refer Friend
                  Row(
                    children: [
                      Expanded(
                        child: MediumRectCard(
                          icon: Icons.badge_sharp,
                          title: 'My KYC',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KycFormPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MediumRectCard(
                          icon: Icons.person_add_alt,
                          title: 'Refer a friend',
                          color: Colors.redAccent,
                          onTap: () {
                            Share.share(
                              'Check out Bottle Bucks App: https://example.com/download',
                              subject: 'Bottle Bucks App',
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Bank Transfer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundOptionCard(
                        icon: Icons.account_balance_outlined,
                        label: 'Bank Transfer',
                        color: Colors.pinkAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BankTransactionPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// ALL YOUR EXISTING WIDGET CLASSES (UNCHANGED)
// ------------------------------------------------------------

enum HomeCardSize { large, medium }

class HomeOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final HomeCardSize size;

  const HomeOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.size = HomeCardSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final double dimension = size == HomeCardSize.large ? 150 : 125;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: dimension,
        width: dimension,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: size == HomeCardSize.large ? 48 : 40,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediumRectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const MediumRectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundOptionCard extends StatelessWidget {
  final IconData? icon; // nullable
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int? points;

  const RoundOptionCard({
    super.key,
    this.icon, // optional
    required this.label,
    required this.color,
    required this.onTap,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // -------------------------------------------------
          // ICON + CIRCLE ONLY IF ICON != NULL
          // -------------------------------------------------
          if (icon != null) ...[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
                border: Border.all(color: color.withOpacity(0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 8),
          ],

          // LABEL
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),

          // POINTS BADGE
          if (points != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$points pts',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

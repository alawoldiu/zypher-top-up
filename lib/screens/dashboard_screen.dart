import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/drawer_widget.dart';
import 'login_screen.dart';
import '../Services/evo_access.dart';
import '../Services/level_up_pass.dart';
import '../Services/uid_bd_server.dart';
import '../Services/weekly_lite.dart';
import '../Services/weekly-monthly.dart';

// বাউন্স ইফেক্ট ক্লাসটি একই থাকবে
class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const BounceButton({super.key, required this.child, required this.onTap});

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: Transform.scale(scale: _scale, child: widget.child),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      endDrawer: const SideDrawer(),
      appBar: _buildAppBar(context, user),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildNoticeBar(),
                  const SizedBox(height: 40),
                  _buildSectionTitle("FREE FIRE TOP UP"),
                  _buildTopUpGrid(context), // context পাস করা হয়েছে
                  const SizedBox(height: 40),
                  _buildSectionTitle("SUPPORT"),
                  _buildSupportSection(context),
                  const SizedBox(height: 40),
                  _buildFreeFireBottomBanner(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpGrid(BuildContext context) {
    // এখানে 'screen' কি নাম হবে তা দিয়ে দিয়েছি
    final List<Map<String, dynamic>> products = [
      {
        "name": "UID Top Up [BD SERVER]",
        "img": "uid top up.png",
        "screen": const UidBdServerScreen(),
      }, // আপনার তৈরি করা স্ক্রিন দিন
      {
        "name": "Weekly / Monthly",
        "img": "weekly-monthly.png",
        "screen": const Placeholder(),
      },
      {
        "name": "Level Up Pass",
        "img": "level up pass.png",
        "screen": const Placeholder(),
      },
      {
        "name": "Weekly Lite",
        "img": "weeklylite.png",
        "screen": const Placeholder(),
      },
      {
        "name": "Evo Access [Uid]",
        "img": "evo_access.png",
        "screen": const Placeholder(),
      },
      {
        "name": "UNIPIN VOUCHER (BDT)",
        "img": "unipin_voucher.png",
        "screen": const Placeholder(),
      },
      {
        "name": "Free Fire Uid [Indonesia]",
        "img": "indonesia.png",
        "screen": const Placeholder(),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800
            ? 6
            : (constraints.maxWidth > 500 ? 4 : 3);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              childAspectRatio: 0.56,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return BounceButton(
                onTap: () {
                  // এখানে নেভিগেশন লজিক অ্যাড করা হয়েছে[cite: 4]
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => products[index]['screen'],
                    ),
                  );
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/${products[index]["img"]}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      products[index]["name"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final List<Map<String, dynamic>> supports = [
      {
        "name": "24/7 Support",
        "img": "Support24-7.png",
        "screen": const Placeholder(), //Here the all new file add.
      },
      {
        "name": "Add Money",
        "img": "add_money.png",
        "screen": const Placeholder(),
      },
      {
        "name": "Telegram",
        "img": "offer_tl.png",
        "screen": const Placeholder(),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth > 800 ? 100 : 20;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: supports.map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BounceButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => item['screen']),
                      );
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/${item["img"]}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["name"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // বাকি AppBar এবং NoticeBar কোড একই থাকবে...[cite: 4]
  Widget _buildNoticeBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "Notice: Welcome to Zypher Top Up - Powered by AI. কোন সমস্যায় পড়লে হোয়াটসঅ্যাপ এ যোগাযোগ করবেন। +8801577342445",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFreeFireBottomBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.asset('assets/images/free_fire.png', fit: BoxFit.contain),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, User? user) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 35),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/banner.png',
            height: 25,
            fit: BoxFit.contain,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "Topup",
            style: TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Contact Us",
            style: TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (user != null) ...[
          _buildBalanceChip(),
          const SizedBox(width: 5),
          _buildProfileIcon(context),
        ] else
          _buildLoginButton(context),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 1, 6, 15),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        "৳ 0",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.person, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

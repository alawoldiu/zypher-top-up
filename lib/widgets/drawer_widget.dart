import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zypher_top_up/screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/add_money_screen.dart';
import '../screens/contact_us_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    // লগইন স্ট্যাটাস চেক
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      // উইন্ডো সাইজ পরিবর্তন করলেও ড্রয়ারের সাইজ ফিক্সড থাকবে
      width: 260,
      child: Column(
        children: [
          // ১. প্রোফাইল হেডার
          _buildHeader(context, user),

          // ২. মেনু লিস্ট
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_outlined,
                  title: "Home",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_box,
                  title: "My Account",
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Add Money",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMoneyScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  title: "My Orders",
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.receipt_long_outlined,
                  title: "Transactions",
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.contact_support_outlined,
                  title: "Contact Us",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactUsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),

                // ইউজার লগইন থাকলে Logout, না থাকলে Login অপশন দেখাবে
                if (user != null)
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: "Logout",
                    color: Colors.red,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  )
                else
                  _buildMenuItem(
                    context,
                    icon: Icons.login,
                    title: "Login",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // ৩. ফুটার: সাহায্য লাগবে টেক্সট এবং কল বাটন পাশাপাশি
          _buildFooterHelp(),
        ],
      ),
    );
  }

  // মেনু আইটেম ডিজাইন (Bold এবং Arrow ছাড়া)
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold, // সব অপশন Bold
        ),
      ),
      onTap: onTap,
      // trailing: অ্যারো রিমুভ করা হয়েছে
    );
  }

  // হেডার সেকশন
  Widget _buildHeader(BuildContext context, User? user) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 15, right: 15),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white24,
            child: user?.photoURL != null
                ? ClipOval(child: Image.network(user!.photoURL!))
                : const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? "Guest User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? "Welcome to Zypher",
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ফুটার সেকশন: সাহায্য লাগবে এবং বাটন পাশাপাশি
  Widget _buildFooterHelp() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              "সাহায্য লাগবে ?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SpeedDial(
            icon: Icons.phone,
            activeIcon: Icons.close,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            mini: true,
            children: [
              SpeedDialChild(
                child: const FaIcon(
                  FontAwesomeIcons.facebookMessenger,
                  color: Colors.white,
                  size: 18,
                ),
                backgroundColor: const Color(0xFF0084FF),
                onTap: () => _launchURL("https://m.me/your_username"),
              ),
              SpeedDialChild(
                child: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 18,
                ),
                backgroundColor: const Color(0xFF25D366),
                onTap: () => _launchURL("https://wa.me/8801577342445"),
              ),
              SpeedDialChild(
                child: const FaIcon(
                  FontAwesomeIcons.telegram,
                  color: Colors.white,
                  size: 18,
                ),
                backgroundColor: const Color(0xFF0088CC),
                onTap: () => _launchURL("https://t.me/Zypher_Top_Up_Helpline"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zypher_top_up/screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/add_money_screen.dart';
import '../screens/contact_us_screen.dart';
import 'package:zypher_top_up/screens/my_orders_screen.dart';

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
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: const Color(0xFF0F1424),
      width: 260,
      child: Column(
        children: [
          // ── Header ──
          _buildHeader(context, user),

          // ── Menu ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                  accentColor: const Color(0xFF00E5FF),
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
                  icon: Icons.account_circle_outlined,
                  title: "My Account",
                  accentColor: const Color(0xFFA259FF),
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Add Money",
                  accentColor: const Color(0xFF22C55E),
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
                  icon: Icons.history_rounded,
                  title: "My Orders",
                  accentColor: const Color(0xFFF59E0B),
                  onTap: () {
                    // Drawer-ti bondho korbe ebong MyOrdersScreen-e niye jabe
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyOrdersScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.receipt_long_outlined,
                  title: "Transactions",
                  accentColor: const Color(0xFF00E5FF),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.contact_support_outlined,
                  title: "Contact Us",
                  accentColor: const Color(0xFFA259FF),
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

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: const Color(0xFF1E2540),
                  ),
                ),

                if (user != null)
                  _buildMenuItem(
                    context,
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    accentColor: const Color(0xFFEF4444),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  )
                else
                  _buildMenuItem(
                    context,
                    icon: Icons.login_rounded,
                    title: "Login",
                    accentColor: const Color(0xFF00E5FF),
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

          // ── Footer ──
          _buildFooterHelp(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color accentColor = const Color(0xFF00E5FF),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF64748B),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user) {
    return Container(
      padding: const EdgeInsets.only(top: 55, bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12172A),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E2540), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF1E2540),
                  child: user?.photoURL != null
                      ? ClipOval(child: Image.network(user!.photoURL!))
                      : const Icon(
                          Icons.person,
                          color: Color(0xFF00E5FF),
                          size: 28,
                        ),
                ),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user?.email ?? "Welcome to Zypher",
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Balance Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0D1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E2540)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFF00E5FF),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Balance',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const Spacer(),
                Text(
                  user != null ? '৳ 0' : '---',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00E5FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterHelp() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1E2540), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.4),
              ),
            ),
            child: const Text(
              "সাহায্য লাগবে ?",
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SpeedDial(
            icon: Icons.phone_rounded,
            activeIcon: Icons.close,
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            mini: true,
            overlayOpacity: 0,
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

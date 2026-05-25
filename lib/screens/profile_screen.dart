import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ফায়ারবেস অথ ইম্পোর্ট
import 'login_screen.dart'; // লগ-আউট করার পর লগ-ইন পেজে যাওয়ার জন্য

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // বর্তমানে লগ-ইন করা ইউজারের ডাটা নেওয়া হচ্ছে
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // ১. ইউজার প্রোফাইল সেকশন (ডাইনামিক ডাটা সহ)
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // এখানে ইউজারের নাম দেখানো হচ্ছে (নাম না থাকলে 'Guest User' দেখাবে)
          Text(
            user?.displayName ?? "Zypher User",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // এখানে ইউজারের ইমেইল দেখানো হচ্ছে
          Text(
            user?.email ?? "No Email found",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          // ২. ব্যালেন্স কার্ড
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "৳ 0.00",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ৩. মেনু অপশনগুলো
          Expanded(
            child: ListView(
              children: [
                _profileMenu(
                  Icons.shopping_basket_outlined,
                  "Total Orders",
                  () {},
                ),
                _profileMenu(
                  Icons.account_balance_wallet_outlined,
                  "My Wallet",
                  () {},
                ),
                _profileMenu(
                  Icons.lock_reset_outlined,
                  "Reset Password",
                  () {},
                ),
                _profileMenu(Icons.support_agent_outlined, "Support", () {}),
                const Divider(height: 30, thickness: 0.5, color: Colors.grey),

                // লগ-আউট বাটন লজিক সহ
                _profileMenu(Icons.logout, "Log Out", () async {
                  await FirebaseAuth.instance.signOut(); // ফায়ারবেস থেকে লগ-আউট
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                }, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileMenu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.deepPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.deepPurple,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.white,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    );
  }
}

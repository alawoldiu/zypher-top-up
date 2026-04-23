import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // ১. ইউজার প্রোফাইল সেকশন
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Zypher User",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text("user@gmail.com", style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 25),

          // ২. ব্যালেন্স কার্ড (GoribGamers স্টাইল)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
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

          // ৩. মেনু অপশনগুলো (GoribGamers এর মতো আইকন সহ)
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
                _profileMenu(Icons.logout, "Log Out", () {}, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // মেনু আইটেম তৈরির কাস্টম ফাংশন
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
              ? Colors.red.withOpacity(0.1)
              : Colors.deepPurple.withOpacity(0.1),
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

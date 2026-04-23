import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // ড্রয়ার সাদা থাকবে ছবির মতো
      width:
          MediaQuery.of(context).size.width *
          0.2, // মেনু স্ক্রিনের 2০% জায়গা নিবে
      child: Column(
        children: [
          // ১. ইউজার প্রোফাইল হেডার (এখানে context পাস করা হয়েছে)
          _buildHeader(context),

          // ২. মেনু লিস্ট
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(Icons.home_outlined, "My Account"),
                _drawerItem(Icons.bookmark_border, "My Orders"),
                _drawerItem(Icons.grid_view, "My Codes"),
                _drawerItem(Icons.list_alt, "My Transaction"),
                _drawerItem(Icons.account_balance_wallet_outlined, "Add Money"),
                _drawerItem(Icons.info_outline, "Contact Us"),

                const SizedBox(height: 20),

                // ৩. সাপোর্ট বাটন
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.headset_mic, color: Colors.white),
                    label: const Text(
                      "Support",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6), // Purple color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ৪. একদম নিচের হেল্প বাটন (লাল রঙের)
          _buildFooter(),
        ],
      ),
    );
  }

  // Header ফাংশনে context গ্রহণ করা হয়েছে যাতে Navigator কাজ করে
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi, alawol us",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "alawolus@gmail.com",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 10),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    // লগআউট করলে সরাসরি লগইন স্ক্রিনে নিয়ে যাবে এবং আগের সব হিস্ট্রি মুছে দিবে
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Logout",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        // মেনু আইটেমে ক্লিক করলে কি হবে এখানে লিখবেন
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              "সাহায্য লাগবে?",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.phone, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

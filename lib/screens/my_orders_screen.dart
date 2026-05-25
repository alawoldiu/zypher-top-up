import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:zypher_top_up/Services/uid_bd_server.dart';
import '../widgets/drawer_widget.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6), // হালকা ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/images/banner.png',
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                "ZYPHER",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          _buildActionBtn("Topup"),
          _buildActionBtn("Contact Us"),
          _buildBalanceChip(),
          const SizedBox(width: 8),
          _buildProfileIcon(_scaffoldKey),
          const SizedBox(width: 15),
        ],
      ),
      endDrawer: const SideDrawer(),
      body: user == null
          ? const Center(child: Text("Please login to see your orders"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 200.0,
                    vertical: 25.0,
                  ),
                  child: Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 27, 40, 219),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('userUid', isEqualTo: user.uid)
                        .orderBy('orderTime', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildEmptyOrderView(context);
                      }

                      return Center(
                        child: Container(
                          // পুরো উইন্ডো সাইজ থেকে একটু কম রাখার জন্য কনস্ট্রেইন
                          constraints: const BoxConstraints(maxWidth: 1200),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return _buildOrderBox(snapshot.data!.docs[index]);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // অর্ডারের বক্স ডিজাইন (Uid Bd Server সেকশন ১ এর মতো)
  Widget _buildOrderBox(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String formattedDate = data['orderTime'] != null
        ? DateFormat(
            'dd-MM-yyyy, hh:mm:ss a',
          ).format((data['orderTime'] as Timestamp).toDate())
        : "N/A";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(25), // বড় সাইজ দেখানোর জন্য বেশি প্যাডিং
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildColumn(
              "Serial No:",
              "${data['serialNo']}",
              "Date:",
              formattedDate,
              "Package:",
              "${data['package']}",
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildColumn(
              "Player ID:",
              "${data['playerId']}",
              "Price:",
              "৳ ${data['price']}",
              "Status:",
              "${data['status']}",
              isStatus: true,
              date: formattedDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(
    String l1,
    String v1,
    String l2,
    String v2,
    String l3,
    String v3, {
    bool isStatus = false,
    String date = "",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _richText(l1, v1),
        const SizedBox(height: 12),
        _richText(l2, v2),
        const SizedBox(height: 12),
        isStatus
            ? RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ), // বড় সাইজ
                  children: [
                    TextSpan(
                      text: l3,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: " ${v3.toLowerCase()}",
                      style: TextStyle(
                        // কালার লজিক এখানে আপডেট করা হয়েছে
                        color: v3.toLowerCase() == 'Completed'
                            ? Colors.green
                            : v3.toLowerCase() == 'completed'
                            ? Colors.green
                            : v3.toLowerCase() == 'Canceled'
                            ? Colors.red
                            : v3.toLowerCase() == 'canceled'
                            ? Colors
                                  .red // ক্যানসেল হলে লাল
                            : Colors.orange, // অন্যথায় কমলা
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: "   ($date)",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )
            : _richText(l3, v3),
      ],
    );
  }

  Widget _richText(String label, String value) => RichText(
    text: TextSpan(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: "Georgia",
      ), // টেক্সট সাইজ বড় করা হয়েছে
      children: [
        TextSpan(
          text: label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        TextSpan(text: " $value"),
      ],
    ),
  );

  // অন্যান্য উইজেটস
  Widget _buildActionBtn(String t) => TextButton(
    onPressed: () {},
    child: Text(
      t,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  Widget _buildBalanceChip() => Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "৳ 0",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),
  );

  Widget _buildProfileIcon(GlobalKey<ScaffoldState> k) => GestureDetector(
    onTap: () => k.currentState?.openEndDrawer(),
    child: const CircleAvatar(
      radius: 16,
      backgroundColor: Colors.blueGrey,
      child: Icon(Icons.person, color: Colors.white, size: 18),
    ),
  );

  Widget _buildEmptyOrderView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.black12,
          ),
          const SizedBox(height: 15),
          const Text(
            "No order history found!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => const UidBdServerScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              "ORDER NOW",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

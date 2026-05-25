import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zypher_top_up/screens/login_screen.dart';
import 'package:zypher_top_up/screens/add_money_screen.dart';
import 'package:zypher_top_up/screens/payment_gateway.dart';
import '../widgets/drawer_widget.dart';

class UidBdServerScreen extends StatefulWidget {
  const UidBdServerScreen({super.key});

  @override
  State<UidBdServerScreen> createState() => _UidBdServerScreenState();
}

class _UidBdServerScreenState extends State<UidBdServerScreen> {
  final TextEditingController playerIdController = TextEditingController();

  String? selectedDiamond;
  String selectedPrice = "0 TK";
  String selectedPaymentMethod = "Instant Pay";

  double userBalance = 0.0; // ফায়ারবেস থেকে রিয়েলটাইম আপডেট হবে

  final List<Map<String, String>> packages = [
    {"diamond": "25 Diamond 💎", "price": "19 TK"},
    {"diamond": "50 Diamond 💎", "price": "35 TK"},
    {"diamond": "75 Diamond 💎", "price": "52 TK"},
    {"diamond": "100 Diamond 💎", "price": "70 TK"},
    {"diamond": "115 Diamond 💎", "price": "75 TK"},
    {"diamond": "150 Diamond 💎", "price": "105 TK"},
    {"diamond": "200 Diamond 💎", "price": "140 TK"},
    {"diamond": "240 Diamond 💎", "price": "150 TK"},
    {"diamond": "355 Diamond 💎", "price": "228 TK"},
    {"diamond": "480 Diamond 💎", "price": "302 TK"},
    {"diamond": "530 Diamond 💎", "price": "334 TK"},
    {"diamond": "610 Diamond 💎", "price": "380 TK"},
    {"diamond": "850 Diamond 💎", "price": "530 TK"},
    {"diamond": "1015 Diamond 💎", "price": "641 TK"},
    {"diamond": "1240 Diamond 💎", "price": "760 TK"},
    {"diamond": "1850 Diamond 💎", "price": "1130 TK"},
    {"diamond": "2530 Diamond 💎", "price": "1520 TK"},
    {"diamond": "5060 Diamond 💎", "price": "3020 TK"},
    {"diamond": "10120 Diamond 💎", "price": "6000 TK"},
    {"diamond": "12650 Diamond 💎", "price": "7500 TK"},
    {"diamond": "20240 Diamond 💎", "price": "12000 TK"},
    {"diamond": "Weekly 1x", "price": "150 TK"},
    {"diamond": "Monthly 1x", "price": "745 TK"},
  ];

  @override
  void initState() {
    super.initState();
    _resetAllFields();
    _fetchUserBalance(); // ব্যালেন্স রিড করা শুরু করবে
  }

  // ফায়ারবেস থেকে রিয়েল-টাইম ব্যালেন্স গেট করার ফাংশন
  void _fetchUserBalance() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              if (mounted) {
                setState(() {
                  userBalance = (snapshot.data()!['balance'] ?? 0.0).toDouble();
                });
              }
            }
          });
    }
  }

  void _resetAllFields() {
    playerIdController.clear();
    selectedDiamond = null;
    selectedPrice = "0 TK";
  }

  @override
  void dispose() {
    playerIdController.dispose();
    super.dispose();
  }

  // --- Firebase-এ অর্ডার সেভ এবং ব্যালেন্স কাটার ফাংশন ---
  Future<void> _processOrder(User user) async {
    int priceValue = int.parse(selectedPrice.split(' ')[0]);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // ১. Firestore-এ অর্ডার ডেটা পাঠানো হচ্ছে
      await FirebaseFirestore.instance.collection('orders').add({
        'userEmail': user.email,
        'userUid': user.uid,
        'playerId': playerIdController.text.trim(),
        'package': selectedDiamond,
        'price': selectedPrice,
        'paymentMethod': selectedPaymentMethod,
        'status': 'Pending',
        'orderTime': FieldValue.serverTimestamp(),
      });

      // ২. যদি Wallet Pay হয়, তবে ইউজারের ব্যালেন্স কমিয়ে দেওয়া
      if (selectedPaymentMethod == "Wallet Pay") {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'balance': userBalance - priceValue});
      }

      if (mounted) {
        Navigator.pop(context); // লোডিং বন্ধ করা
        _showSnackBar("অর্ডার সফলভাবে সাবমিট হয়েছে!", Colors.green);
        _resetAllFields();
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar("অর্ডার করতে সমস্যা হয়েছে: $e", Colors.red);
      }
    }
  }

  void _handlePaymentProcess(User user) {
    int price = int.parse(selectedPrice.split(' ')[0]);

    if (selectedPaymentMethod == "Wallet Pay") {
      if (userBalance < price) {
        _showSnackBar(
          "পর্যাপ্ত ব্যালেন্স নেই! টাকা অ্যাড করুন।",
          Colors.orange,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddMoneyScreen()),
        );
      } else {
        _processOrder(user);
      }
    } else if (selectedPaymentMethod == "Instant Pay") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentGatewayScreen(amount: price.toString()),
        ),
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      endDrawer: const SideDrawer(),
      appBar: _buildAppBar(context, user),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 800;
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _buildProductHeader(),
                      const SizedBox(height: 20),
                      if (isMobile) ...[
                        _buildSelectRechargeSection(),
                        const SizedBox(height: 20),
                        _buildAccountInfoSection(),
                        const SizedBox(height: 20),
                        _buildPaymentSection(user),
                      ] else ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildSelectRechargeSection(),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _buildAccountInfoSection(),
                                  const SizedBox(height: 20),
                                  _buildPaymentSection(user),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 30),
                      _buildRulesSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- ১ নম্বর সেকশন ---
  Widget _buildSelectRechargeSection() {
    return Container(
      padding: const EdgeInsets.all(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle("1", "Select Recharge"),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3.2,
                ),
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      selectedDiamond == packages[index]["diamond"];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDiamond = packages[index]["diamond"];
                        selectedPrice = packages[index]["price"]!;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : Colors.grey.shade100,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected
                            ? const Color(0xFF8B5CF6).withOpacity(0.08)
                            : const Color(0xFFFAFBFF),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.grey.shade400,
                              ),
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 10,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              packages[index]["diamond"]!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            packages[index]["price"]!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // --- ২ নম্বর সেকশন ---
  Widget _buildAccountInfoSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle("2", "Account Info"),
          const SizedBox(height: 20),
          const Text(
            "Player Id",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: playerIdController,
            decoration: InputDecoration(
              hintText: "Enter ID",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ৩ নম্বর সেকশন ---
  Widget _buildPaymentSection(User? user) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle("3", "Select one option"),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildPaymentCard(
                "Wallet Pay",
                "assets/images/wallet.png",
                selectedPaymentMethod == "Wallet Pay",
                () => setState(() => selectedPaymentMethod = "Wallet Pay"),
              ),
              const SizedBox(width: 10),
              _buildPaymentCard(
                "Instant Pay",
                "assets/images/autopay.png",
                selectedPaymentMethod == "Instant Pay",
                () => setState(() => selectedPaymentMethod = "Instant Pay"),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            Icons.account_balance_wallet_outlined,
            "আপনার অ্যাকাউন্ট ব্যালেন্স : ",
            "৳ ${userBalance.toStringAsFixed(2)}",
            true,
          ),
          const SizedBox(height: 5),
          _buildInfoRow(
            Icons.shopping_cart_outlined,
            "প্রোডাক্ট কিনতে আপনার প্রয়োজন : ",
            "৳ $selectedPrice",
            false,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (user == null) {
                  _showSnackBar(
                    "অর্ডার করতে দয়া করে লগইন করুন।",
                    Colors.orange,
                  );
                } else if (selectedDiamond == null) {
                  _showSnackBar("একটি প্যাকেজ সিলেক্ট করুন।", Colors.red);
                } else if (playerIdController.text.trim().isEmpty) {
                  _showSnackBar("আপনার Player ID প্রদান করুন।", Colors.red);
                } else {
                  _handlePaymentProcess(user);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- অন্যান্য UI উইজেটস ---
  Widget _buildRulesSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.rule_folder_outlined,
                  color: Color(0xFF1A237E),
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  "Rules & Conditions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                _buildRuleItem(
                  "শুধুমাত্র Bangladesh সার্ভারে ID Code দিয়ে টপ আপ হবে।",
                ),
                _buildRuleItem(
                  "Player ID code ভুলে দিলে Diamond না পেলে Gorib Gamers কর্তৃপক্ষ দায়ী নয়।",
                ),
                _buildRuleItem(
                  "Order কমপ্লিট হওয়ার পরেও আইডিতে ডায়মন্ড না গেলে চেক করার জন্য ID Pass দিতে হবে।",
                ),
                _buildRuleItem(
                  "অর্ডার Cancel হলে কি কারণে তা Cancel হয়েছে তা অর্ডারের হিস্টোরিতে দেওয়া থাকে।",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 8, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, User? user) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 40),
          const SizedBox(width: 8),
          Flexible(
            child: Image.asset(
              'assets/images/banner.png',
              height: 25,
              fit: BoxFit.contain,
            ),
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
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Contact Us",
            style: TextStyle(
              color: Color(0xFF1A237E),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 5),
        if (user != null) ...[
          _buildBalanceChip(),
          const SizedBox(width: 8),
          _buildProfileIcon(context),
        ] else
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildStepTitle(String step, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFF7C4DFF),
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 2.5, width: 50, color: const Color(0xFF7C4DFF)),
      ],
    );
  }

  Widget _buildPaymentCard(
    String title,
    String img,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.red : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(img, height: 40),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                color: isSelected
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey.shade100,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.red : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool refresh,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF7C4DFF),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        if (refresh) const Icon(Icons.refresh, size: 14, color: Colors.grey),
      ],
    );
  }

  // ব্যালেন্স চিপ আপডেট করা হয়েছে
  Widget _buildBalanceChip() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          "৳ ${userBalance.toStringAsFixed(0)}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
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
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/uid top up.png',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Uid Topup [BD SERVER]",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Game / Top up",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

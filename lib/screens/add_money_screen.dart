import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drawer_widget.dart';
import 'payment_gateway.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _errorMessage;

  // লিঙ্ক ওপেন করার ফাংশন
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("লিঙ্কটি ওপেন করা সম্ভব হচ্ছে না: $url");
    }
  }

  void _handleAddMoney() {
    final int? amount = int.tryParse(_amountController.text);
    setState(() {
      if (_amountController.text.isEmpty) {
        _errorMessage = "Amount Is Required And Must Be A Number";
      } else if (amount == null || amount < 10) {
        _errorMessage = "সর্বনিম্ন ১০ টাকা অ্যাড করতে পারবেন";
      } else if (amount > 4900) {
        _errorMessage = "সর্বোচ্চ ৪৯০০ টাকা পর্যন্ত অ্যাড করতে পারবেন";
      } else {
        _errorMessage = null;
        showDialog(
          context: context,
          builder: (context) =>
              PaymentGatewayScreen(amount: _amountController.text),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      endDrawer: const SideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
          TextButton(
            onPressed: () {},
            child: const Text(
              "Topup",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    // Add Money Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Add Money",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Enter the amount",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Amount",
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: _errorMessage != null
                                            ? Colors.red
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: _errorMessage != null
                                            ? Colors.red
                                            : Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: _handleAddMoney,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8B5CF6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      "Click Here To Add Money",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Video Tutorial Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.monitor_outlined,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "How to add money",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Container(
                            height: 250,
                            width: double.infinity,
                            margin: const EdgeInsets.all(15),
                            color: const Color(0xFFE5E7EB),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // --- Floating Action Button Section ---
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // সাহায্য লাগবে লেবেল
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              "সাহায্য লাগবে ?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // স্পিড ডায়াল মেনু
          SpeedDial(
            icon: Icons.phone_in_talk,
            activeIcon: Icons.close,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            spacing: 12,
            children: [
              SpeedDialChild(
                child: const FaIcon(
                  FontAwesomeIcons.facebookMessenger,
                  color: Colors.white,
                  size: 20,
                ),
                backgroundColor: const Color(0xFF0084FF),
                onTap: () => _launchURL("https://m.me/your_username"),
              ),
              SpeedDialChild(
                child: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 20,
                ),
                backgroundColor: const Color(0xFF25D366),
                onTap: () => _launchURL("https://wa.me/+8801577342445"),
              ),
              SpeedDialChild(
                child: const FaIcon(
                  FontAwesomeIcons.telegram,
                  color: Colors.white,
                  size: 20,
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

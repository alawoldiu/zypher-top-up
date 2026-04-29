import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NagadPaymentScreen extends StatelessWidget {
  final String amount;
  const NagadPaymentScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    const String targetNumber = "01611184808"; // Nagad target number

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Container(
            width: double.infinity,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ১. হেডার অংশ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, size: 18),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.g_translate,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 15),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Nagad Logo (Ensure assets/images/nagad.png exists)
                    Image.asset("assets/images/nogod.png", height: 70),
                    const SizedBox(height: 25),

                    // ২. নোটিশ এবং ডাইনামিক অ্যামাউন্ট
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Zypher Top Up -এ আপনি সর্বনিম্ন ১০ টাকা থেকে শুরু করে সর্বোচ্চ ৪৯০০ টাকা পর্যন্ত অ্যাড করতে পারবেন",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "৳ $amount",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xFF4A5568),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // ৩. ইনস্ট্রাকশন প্যানেল (Nagad Theme Color: #F44336)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          229,
                          43,
                          29,
                        ), // Nagad Red Color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "ট্রানজ্যাকশন আইডি দিন",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: "ট্রানজ্যাকশন আইডি দিন",
                              hintStyle: const TextStyle(color: Colors.grey),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // ইনস্ট্রাকশন স্টেপস (Hu-bu Copy Style)
                          _buildStep(
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: "• "),
                                  _boldSpan("*167#"),
                                  const TextSpan(text: " ডায়াল করে আপনার "),
                                  _boldSpan("Nagad"),
                                  const TextSpan(
                                    text: " মোবাইল মেনুতে যান অথবা ",
                                  ),
                                  _boldSpan("Nagad"),
                                  const TextSpan(text: " অ্যাপে যান।"),
                                ],
                              ),
                            ),
                          ),

                          _buildStep(
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: "• "),
                                  _boldSpan("\"Send Money\""),
                                  const TextSpan(text: " -এ ক্লিক করুন।"),
                                ],
                              ),
                            ),
                          ),

                          // ৪. কপি বাটনসহ নম্বর স্টেপ
                          _buildStep(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "• ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text:
                                              "প্রাপক নম্বর হিসেবে এই নম্বরটি লিখুন: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: targetNumber,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFEB3B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                      const ClipboardData(text: targetNumber),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Number Copied!"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Copy",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildStep(
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: "• টাকার পরিমাণ: "),
                                  _boldSpan("৳ $amount"),
                                ],
                              ),
                            ),
                          ),

                          _buildStep(
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "• নিশ্চিত করতে এখন আপনার ",
                                  ),
                                  _boldSpan("Nagad"),
                                  const TextSpan(
                                    text: " মোবাইল মেনু পিন লিখুন।",
                                  ),
                                ],
                              ),
                            ),
                          ),

                          _buildStep(
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "• সবকিছু ঠিক থাকলে, আপনি ",
                                  ),
                                  _boldSpan("Nagad"),
                                  const TextSpan(
                                    text: " থেকে একটি নিশ্চিতকরণ বার্তা পাবেন।",
                                  ),
                                ],
                              ),
                            ),
                          ),

                          _buildStep(
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "• এখন উপরের বক্সে আপনার ",
                                  ),
                                  _boldSpan("Transaction ID"),
                                  const TextSpan(text: " দিন এবং নিচের "),
                                  _boldSpan("VERIFY"),
                                  const TextSpan(text: " বাটনে ক্লিক করুন।"),
                                ],
                              ),
                            ),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ৫. ভেরিফাই বাটন
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            235,
                            33,
                            33,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "VERIFY",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static TextSpan _boldSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Color(0xFFFFEB3B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStep(Widget content, {bool isLast = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
      ),
      child: content,
    );
  }
}

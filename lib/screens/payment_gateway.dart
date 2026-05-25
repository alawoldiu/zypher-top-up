import 'package:flutter/material.dart';
import 'bkash_payment.dart';
import 'nagad_payment.dart';

class PaymentGatewayScreen extends StatelessWidget {
  final String amount;

  const PaymentGatewayScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // হেডার
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home_outlined, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // লোগো ও বর্ণনা
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.bolt, color: Colors.deepPurple, size: 45),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Zypher Top Up -এ আপনি সর্বনিম্ন ১০ টাকা থেকে শুরু করে সর্বোচ্চ ৪৯০০ টাকা পর্যন্ত অ্যাড করতে পারবেন",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // মোবাইল ব্যাংকিং বাটন
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "মোবাইল ব্যাংকিং",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- বিকাশ ও নগদ অপশন (অ্যানিমেশনসহ) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentMethodItem(
                  method: "bKash",
                  imagePath: "assets/images/bkash.png",
                  amount: amount,
                ),
                PaymentMethodItem(
                  method: "Nagad",
                  imagePath: "assets/images/nogod.png",
                  amount: amount,
                ),
              ],
            ),
            const SizedBox(height: 35),

            // পে বাটন
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Paying $amount BDT");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE3F2FD),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.blue.shade100),
                ),
                child: Text(
                  "Pay $amount.00 BDT",
                  style: const TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- জুম অ্যানিমেশনের জন্য আলাদা উইজেট ---
class PaymentMethodItem extends StatefulWidget {
  final String method;
  final String imagePath;
  final String amount;

  const PaymentMethodItem({
    super.key,
    required this.method,
    required this.imagePath,
    required this.amount,
  });

  @override
  State<PaymentMethodItem> createState() => _PaymentMethodItemState();
}

class _PaymentMethodItemState extends State<PaymentMethodItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Widget targetScreen = (widget.method == "bKash")
              ? BkashPaymentScreen(amount: widget.amount)
              : NagadPaymentScreen(amount: widget.amount);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0, // হোভার করলে ১০% বড় হবে
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            width: 130,
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _isHovered
                    ? Colors.deepPurple.shade200
                    : Colors.grey.shade300,
                width: _isHovered ? 1.5 : 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

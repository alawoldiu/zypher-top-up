import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drawer_widget.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // ড্রয়ারটি ডান পাশে থাকবে
      endDrawer: const SideDrawer(),
      appBar: _buildAppBar(context),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // ১. সার্ভিস কার্ড সেকশন
              _buildFirstSection(),
              const SizedBox(height: 40),
              // ২. ডিটেইলস এবং হেল্পলাইন সেকশন
              _buildSecondSection(),
              const SizedBox(height: 100),
              _buildFooter(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFixedHelpButton(),
    );
  }

  // --- অ্যাপবার সেকশন (প্রোফাইল ক্লিক লজিক সহ) ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
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
        TextButton(
          onPressed: () {},
          child: const Text("Topup", style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Contact Us",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),

        // প্রোফাইল আইকন: এখানে ক্লিক করলে ড্রয়ার ওপেন হবে
        Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openEndDrawer(); // ডান পাশের ড্রয়ার কল
            },
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  // --- প্রথম সেকশন (সার্ভিস কার্ড) ---
  Widget _buildFirstSection() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _contactCard(
                    icon: Icons.phone_in_talk,
                    text: "সরাসরি কথা বলতে ক্লিক করুন।",
                    color: Colors.blue,
                    onTap: () => _launchURL("tel:+8801577342445"),
                  ),
                  _contactCard(
                    icon: FontAwesomeIcons.facebookMessenger,
                    text: "মেসেঞ্জারে চ্যাট করুন।",
                    color: Colors.purple,
                    onTap: () => _launchURL("https://m.me/your_username"),
                  ),
                  _contactCard(
                    icon: FontAwesomeIcons.whatsapp,
                    text: "হোয়াটসঅ্যাপে চ্যাট করুন।",
                    color: Colors.green,
                    onTap: () => _launchURL("https://wa.me/8801577342445"),
                  ),
                  _contactCard(
                    icon: FontAwesomeIcons.telegram,
                    text: "টেলিগ্রামে কথা বলুন।",
                    color: Colors.lightBlue,
                    onTap: () =>
                        _launchURL("https://t.me/Zypher_Top_Up_Helpline"),
                  ),
                  _contactCard(
                    icon: Icons.email,
                    text: "সাপোর্টে ইমেইল করুন।",
                    color: Colors.orange,
                    onTap: () =>
                        _launchURL("mailto:alawolhossain771@gmail.com"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- দ্বিতীয় সেকশন (রেসপন্সিভ ব্যানার এবং হেল্পলাইন) ---
  Widget _buildSecondSection() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 40,
            runSpacing: 30,
            children: [
              // বাম পাশ (ব্যানার এবং নোটিশ)
              SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image, size: 30),
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          'assets/images/banner.png',
                          height: 38,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "কোন সমস্যায় পড়লে হোয়াটসঅ্যাপ এ যোগাযোগ করবেন। তাহলে দ্রুত সমাধান পেয়ে যাবেন।",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "নোটিশ:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      "কোন সমস্যায় পড়লে হোয়াটসঅ্যাপ এ যোগাযোগ করবেন। দ্রুত সমাধান পেয়ে যাবেন।",
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // ডান পাশ (হেল্পলাইন লিস্ট)
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    _helplineTile(
                      FontAwesomeIcons.whatsapp,
                      "Whatsapp HelpLine",
                      Colors.green,
                      "https://wa.me/8801577342445",
                    ),
                    _helplineTile(
                      FontAwesomeIcons.telegram,
                      "Telegram HelpLine",
                      Colors.blue,
                      "https://t.me/Zypher_Top_Up_Helpline",
                    ),
                    _helplineTile(
                      FontAwesomeIcons.facebookMessenger,
                      "Facebook HelpLine",
                      Colors.blueAccent,
                      "https://m.me/your_username",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF8FAFC),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _helplineTile(IconData icon, String title, Color color, String link) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(link),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "সকাল ৮টা থেকে রাত ১২টা",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.blue, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedHelpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            "সাহায্য লাগবে ?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        SpeedDial(
          icon: Icons.phone_in_talk,
          activeIcon: Icons.close,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          children: [
            SpeedDialChild(
              child: const FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              onTap: () => _launchURL("https://wa.me/8801577342445"),
            ),
            SpeedDialChild(
              child: const FaIcon(
                FontAwesomeIcons.telegram,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              onTap: () => _launchURL("https://t.me/Zypher_Top_Up_Helpline"),
            ),
            SpeedDialChild(
              child: const FaIcon(
                FontAwesomeIcons.facebookMessenger,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              onTap: () => _launchURL("https://m.me/your_username"),

              //messenger help profile username update korte hobe
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        "All Rights Reserved | Developed By Md. Alawol Hosian Nelu",
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart'; // ড্রয়ারের জন্য আলাদা ফাইল

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zypher TopUp"),
        centerTitle: true,
        actions: [
          // প্রোফাইল আইকন - এটা ক্লিক করলে ডান পাশের ড্রয়ার খুলবে
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.person_outline, size: 30),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      // ডান পাশের ড্রয়ার
      endDrawer: const SideDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildCard("Free Fire", Icons.local_fire_department),
                _buildCard("Weekly", Icons.calendar_view_week),
                _buildCard("Monthly", Icons.calendar_month),
                _buildCard("Top Up", Icons.add_shopping_cart),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.deepPurple),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // নতুন যোগ করা হয়েছে
import 'firebase_options.dart'; // কনফিগারেশন ফাইল
import 'screens/dashboard_screen.dart';

void main() async {
  // Flutter binding নিশ্চিত করা (Firebase এর জন্য জরুরি)
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ইনিশিয়ালাইজ করা
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ZypherTopUp());
}

class ZypherTopUp extends StatelessWidget {
  const ZypherTopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zypher TopUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // আপনি যেহেতু scaffoldBackgroundColor ডার্ক দিয়েছেন, তাই brightness ডার্ক রাখাই ভালো
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true, // আধুনিক লুকের জন্য
      ),
      home: const DashboardScreen(),
    );
  }
}

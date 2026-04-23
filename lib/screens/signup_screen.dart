import 'package:flutter/material.dart';
import 'package:zypher_top_up/screens/login_screen.dart';
import 'package:zypher_top_up/services/auth_service.dart'; // নিশ্চিত করুন এই পাথটি ঠিক আছে

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isObscure = true;

  // ১. কন্ট্রোলারগুলো যোগ করা হয়েছে
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // আপনার তৈরি করা সেই সার্ভিস

  // সাইন আপ লজিক ফাংশন
  void _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields!")));
      return;
    }

    // ২. ফায়ারবেসে ডাটা পাঠানো
    String? result = await _authService.signUp(name, email, password);

    if (result == "Success") {
      // ৩. সফল হলে মেসেজ দেখানো
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign up successful! Please login."),
            backgroundColor: Colors.green,
          ),
        );
        // ৪. লগ-ইন পেজে নিয়ে যাওয়া
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // এরর হলে দেখানো
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? "Signup Failed ! Please Try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF63D8D8), Color(0xFF3B82F6)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create your\nAccount",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 60),

                // ইউজার নেম ফিল্ড (Controller যুক্ত)
                _buildTransparentField(
                  hint: "User Name",
                  icon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 25),

                // ইমেইল ফিল্ড (Controller যুক্ত)
                _buildTransparentField(
                  hint: "example@gmail.com",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                ),
                const SizedBox(height: 25),

                // পাসওয়ার্ড ফিল্ড
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: _passwordController, // Controller যুক্ত
                            obscureText: _isObscure,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _isObscure = !_isObscure),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white54, thickness: 1),
                  ],
                ),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have Account Sign In?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // ৪. সাইন আপ বাটন (লজিক কল করা হয়েছে)
                Center(
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(220, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ট্রান্সপারেন্ট ফিল্ড মেথড (Controller প্যারামিটার যোগ করা হয়েছে)
  Widget _buildTransparentField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controller, // এখানে কন্ট্রোলারটি বসবে
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white54, thickness: 1),
      ],
    );
  }
}

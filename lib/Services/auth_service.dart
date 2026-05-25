import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore ইম্পোর্ট যুক্ত করা হয়েছে

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore ইনস্ট্যান্স

  // রেজিস্ট্রেশন (নামসহ এবং ডাটাবেসে ইউজার তৈরি)
  Future<String?> signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // ইউজারের নাম আপডেট করা
        await user.updateDisplayName(name);

        // Firestore-এ 'users' কালেকশনে নতুন ডকুমেন্ট তৈরি
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'uid': user.uid,
          'balance': 0.0, // ডিফল্ট ব্যালেন্স ০ সেট করা হলো
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // লগ-ইন
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // লগ-আউট
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

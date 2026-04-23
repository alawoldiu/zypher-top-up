import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // রেজিস্ট্রেশন (নামসহ)
  Future<String?> signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ইউজারের নাম আপডেট করা
      await result.user?.updateDisplayName(name);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
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

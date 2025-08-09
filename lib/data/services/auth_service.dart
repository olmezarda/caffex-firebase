import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential> signInWithEmail(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<UserCredential> signUpWithEmail(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static User? get currentUser => _auth.currentUser;
}

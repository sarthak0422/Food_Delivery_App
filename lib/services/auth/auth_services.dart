import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Single Firebase instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Add 'static' here so the ID persists across different screens
  static String? _verificationId;

  // String? _verificationId; // Stores OTP verification ID

  // =========================
  // CURRENT USER
  // =========================
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // =========================
  // EMAIL & PASSWORD SIGN IN
  // =========================
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  // =========================
  // EMAIL & PASSWORD SIGN UP
  // =========================
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  // =========================
  // SIGN OUT
  // =========================
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // =========================
  // SEND OTP TO PHONE
  // =========================
  Future<void> verifyPhone(
      String phoneNumber,
      Function(String) onCodeSent,
      ) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        // Auto verification (Android)
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message ?? "Phone verification failed");
        },

        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId); // Trigger OTP UI
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      throw Exception("Failed to send OTP: $e");
    }
  }

  // =========================
  // VERIFY OTP & SIGN IN
  // =========================
  Future<UserCredential> loginInWithOTP(String smsCode) async {
    if (_verificationId == null) {
      throw Exception("Verification ID not found. Request OTP again.");
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Invalid OTP code");
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // get instance of firebase auth
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//get current user
User? getCurrentUser() {
  return _firebaseAuth.currentUser;
}

//sign in
Future<UserCredential> signInWithEmailPassword(String email, password) async {
  //try sign user in
  try{
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }
  //catch any errors
  on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}
//sign up
Future<UserCredential> signUpWithEmailPassword(String email, password) async {
  //try sign user up
  try{
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }
  //catch any errors
  on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

//sign out
Future<void> signOut() async {
  return await _firebaseAuth.signOut();
}


// Send OTP to Phone
  Future<void> verifyPhoneNumber(String phoneNumber, Function(String) codeSent) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

// Sign in with OTP
  Future<UserCredential> signInWithOTP(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // We use a getter for the UID to ensure it's always fresh
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  // Stream of user data for the Profile Page
  Stream<DocumentSnapshot> get userProfileStream {
    return _db.collection('users').doc(uid).snapshots();
  }

  // CREATE or UPDATE user profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? address,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address ?? "No address set",
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save profile: $e");
    }
  }

  Future<void> saveUserLocally(String name, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_uid', uid);
    await prefs.setBool('is_logged_in', true);
  }
}


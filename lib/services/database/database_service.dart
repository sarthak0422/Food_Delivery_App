import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Stream of user data (updates UI automatically when data changes)
  Stream<UserProfile> get userProfileStream {
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Update user data
  Future<void> updateProfile(String name, String address) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'address': address,
      'uid': uid,
      'email': FirebaseAuth.instance.currentUser!.email,
    }, SetOptions(merge: true));
  }
}
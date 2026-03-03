class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String address;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
  });

  // Convert Firestore Document to Object
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? 'New User',
      email: map['email'] ?? '',
      address: map['address'] ?? 'Add your address',
    );
  }

  // Convert Object to Map for Saving
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
    };
  }
}
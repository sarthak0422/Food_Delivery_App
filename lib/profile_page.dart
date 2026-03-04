// import 'package:flutter/material.dart';
// import 'package:untitled/services/database/database_service.dart';
// import 'package:untitled/models/user_profile.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final DatabaseService _db = DatabaseService();
//   bool _isEditing = false;
//
//   // Controllers for text fields
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("P R O F I L E"),
//         actions: [
//           IconButton(
//             icon: Icon(_isEditing ? Icons.check_circle : Icons.edit),
//             onPressed: () async {
//               if (_isEditing) {
//                 // Save to Backend
//                 await _db.updateProfile(_nameController.text, _addressController.text);
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Profile Updated!")),
//                   );
//                 }
//               }
//               setState(() => _isEditing = !_isEditing);
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<UserProfile>(
//         stream: _db.userProfileStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//
//           var user = snapshot.data!;
//           // Set initial values for controllers
//           if (!_isEditing) {
//             _nameController.text = user.name;
//             _addressController.text = user.address;
//           }
//
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // Avatar (Stays the same as previous)
//                 _buildAvatar(),
//
//                 const SizedBox(height: 30),
//
//                 // Editable Fields
//                 _buildField("Name", _nameController, Icons.person, _isEditing),
//                 _buildField("Email", TextEditingController(text: user.email), Icons.email, false), // Email usually not editable
//                 _buildField("Address", _addressController, Icons.location_on, _isEditing),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildField(String label, TextEditingController controller, IconData icon, bool enabled) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondary,
//         borderRadius: BorderRadius.circular(15),
//         border: enabled ? Border.all(color: Theme.of(context).colorScheme.primary) : null,
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
//         title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         subtitle: TextField(
//           controller: controller,
//           enabled: enabled,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           decoration: const InputDecoration(border: InputBorder.none, isDense: true),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAvatar() {
//     return Center(
//       child: CircleAvatar(
//         radius: 65,
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         child: const CircleAvatar(
//           radius: 62,
//           backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
//         ),
//       ),
//     );
//   }
// }


//without database connected
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled/models/restaurant.dart';
import 'package:untitled/services/database/database_service.dart';

import 'components/my_skeleton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseService _db = DatabaseService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: currentUser?.displayName ?? "");
    _emailController =
        TextEditingController(text: currentUser?.email ?? "");
    _phoneController =
        TextEditingController(text: currentUser?.phoneNumber ?? "");
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ✅ Saving Overlay
  void _showSavingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Saving..."),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Save Profile (Production Ready)
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty!")),
      );
      return;
    }

    _showSavingOverlay();

    try {
      await currentUser?.updateDisplayName(_nameController.text.trim());

      await _db.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context); // remove overlay

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  // ✅ Skeleton Loader
  Widget _buildProfileSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Avatar Skeleton
          const MySkeleton(height: 120, width: 120, borderRadius: 60),

          const SizedBox(height: 40),

          // Field Skeletons
          ...List.generate(4, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: MySkeleton(
              height: 70,
              width: MediaQuery.of(context).size.width,
            ),
          )),
        ],
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, String receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Order Details"),
        content: SingleChildScrollView(child: Text(receipt)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("P R O F I L E"),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing
                  ? Icons.check_circle_rounded
                  : Icons.edit_note_rounded,
            ),
            color: _isEditing ? Colors.green : null,
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),

      // 🔥 Firestore Stream
      body: StreamBuilder<DocumentSnapshot>(
        stream: _db.userProfileStream,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildProfileSkeleton();
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            if (!_isEditing) {
              _nameController.text = userData['name'] ?? currentUser?.displayName ?? "";
              _addressController.text = userData['address'] ?? "No address set";
              // Also update phone/email if they are empty in the controllers
              _emailController.text = userData['email'] ?? currentUser?.email ?? "";
              _phoneController.text = userData['phone'] ?? currentUser?.phoneNumber ?? "";
            }
          } else if (snapshot.hasData && !snapshot.data!.exists) {
            // If document doesn't exist, show Auth data as fallback
            if (!_isEditing) {
              _nameController.text = currentUser?.displayName ?? "";
              _emailController.text = currentUser?.email ?? "";
              _phoneController.text = currentUser?.phoneNumber ?? "";
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: const NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                _buildProfileField(
                  label: "Full Name",
                  controller: _nameController,
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                ),

                _buildProfileField(
                  label: "Email",
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  enabled: false,
                ),

                _buildProfileField(
                  label: "Phone",
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  enabled: false,
                ),

                _buildProfileField(
                  label: "Address",
                  controller: _addressController,
                  icon: Icons.location_on_outlined,
                  enabled: _isEditing,
                  maxLines: 2,
                ),

                const SizedBox(height: 30),

                const Text(
                  "Order History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Consumer<Restaurant>(
                  builder: (context, restaurant, child) {
                    if (restaurant.orderHistory.isEmpty) {
                      return const Text("No past orders yet.");
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: restaurant.orderHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(
                              "Order #${restaurant.orderHistory.length - index}"),
                          subtitle:
                          const Text("Tap to view details"),
                          onTap: () => _showReceiptDialog(
                            context,
                            restaurant.orderHistory[index],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: enabled
            ? Border.all(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(0.5),
        )
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.6),
                  ),
                ),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  decoration:
                  const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    EdgeInsets.only(top: 5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
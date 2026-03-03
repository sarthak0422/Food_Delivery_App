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


//wihout database connected
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/restaurant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "John Doe";
  String email = "johndoe@example.com";
  String address = "123 Foodie Lane, Mumbai";

  late TextEditingController _nameController;
  late TextEditingController _addressController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: name);
    _addressController = TextEditingController(text: address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      name = _nameController.text;
      address = _addressController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Profile Updated locally!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // ---------------- RECEIPT DIALOG ----------------

  void _showReceiptDialog(BuildContext context, String receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          "Order Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // Using a lighter background color for the "paper" effect
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              border: Border.all(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              receipt,
              style: TextStyle(
                // REMOVED 'Courier' to use the app's default font
                fontSize: 15,
                height: 1.5, // Better line spacing for readability
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("P R O F I L E"),
        actions: [
          IconButton(
            onPressed:
            _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
            icon: Icon(
              _isEditing
                  ? Icons.check_circle_rounded
                  : Icons.edit_note_rounded,
            ),
            color: _isEditing
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor:
                  Theme.of(context).colorScheme.secondary,
                  backgroundImage: const NetworkImage(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                  ),
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
              label: "Email Address",
              controller: TextEditingController(text: email),
              icon: Icons.email_outlined,
              enabled: false,
            ),

            _buildProfileField(
              label: "Delivery Address",
              controller: _addressController,
              icon: Icons.location_on_outlined,
              enabled: _isEditing,
              maxLines: 2,
            ),

            const SizedBox(height: 30),

            // ---------------- ORDER HISTORY SECTION ----------------

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Order History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Consumer<Restaurant>(
              builder: (context, restaurant, child) {
                if (restaurant.orderHistory.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("No past orders yet."),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurant.orderHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.history_edu),
                      title: Text(
                          "Order #${restaurant.orderHistory.length - index}"),
                      subtitle: const Text("Tap to view details"),
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
      ),
    );
  }

  // ---------------- REUSABLE FIELD ----------------

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
                .withOpacity(0.5))
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5),
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
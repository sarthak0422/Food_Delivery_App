import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/components/my_drawer_tile.dart';
import 'package:untitled/services/auth/auth_gate.dart';
import 'package:untitled/services/auth/auth_services.dart';
import 'package:untitled/settings_page.dart';
import '../profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authServices = AuthService();
    authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Drawer Header with User Info
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_2_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 10),
                Text(
                  FirebaseAuth.instance.currentUser?.email ??
                      FirebaseAuth.instance.currentUser?.phoneNumber ??
                      "Guest User",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // Home list tile
          MyDrawerTile(
              onTap: () => Navigator.pop(context),
              text: "H O M E",
              icon: Icons.home_rounded
          ),

          MyDrawerTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            text: "P R O F I L E",
            icon: Icons.person_outline_rounded,
          ),

          MyDrawerTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
              text: "S E T T I N G S",
              icon: Icons.settings
          ),

          const Spacer(),

          // Logout
          MyDrawerTile(
              onTap: ()  {
                logout();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthGate()));
              },
              text: "L O G O U T",
              icon: Icons.logout_rounded
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // --- APPEARANCE SECTION ---
          _buildSectionHeader("Appearance"),

          _buildSettingsTile(
            context,
            title: "Dark Mode",
            subtitle: "Adjust the app look",
            icon: Icons.dark_mode_rounded,
            iconColor: Colors.blue,
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) => CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // --- NOTIFICATIONS SECTION ---
          _buildSectionHeader("Notifications"),

          _buildSettingsTile(
            context,
            title: "Push Notifications",
            subtitle: "Daily offers & order updates",
            icon: Icons.notifications_active_rounded,
            iconColor: Colors.orange,
            trailing: CupertinoSwitch(
              value: true, // Mock value
              onChanged: (value) {},
            ),
          ),

          const SizedBox(height: 10),

          // --- ABOUT SECTION ---
          _buildSectionHeader("More"),

          _buildSettingsTile(
            context,
            title: "About Us",
            subtitle: "Learn more about our kitchen",
            icon: Icons.info_outline_rounded,
            iconColor: Colors.teal,
            onTap: () {
              // Show a modern About Dialog
              showAboutDialog(
                context: context,
                applicationName: "Untitled Food App",
                applicationVersion: "1.0.0",
                applicationIcon: Icon(Icons.restaurant, color: Theme.of(context).colorScheme.primary),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS FOR SHINY UI ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color iconColor,
        Widget? trailing,
        void Function()? onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
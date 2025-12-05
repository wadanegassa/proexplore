import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (val) => provider.toggleTheme(val),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          ),
          const ListTile(
            title: Text('Offline Data'),
            subtitle: Text('Manage downloaded guides and maps'),
            leading: Icon(Icons.download_done),
          ),
          const ListTile(
            title: Text('About ProTravel'),
            subtitle: Text('Version 1.0.0'),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}

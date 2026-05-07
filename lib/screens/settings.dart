import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylebook_salon_app/providers/app_state.dart';
import 'package:stylebook_salon_app/utils/colors.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _SectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme throughout the app'),
            value: appState.isDarkMode,
            onChanged: (v) => context.read<AppState>().setDarkMode(v),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          _SectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Booking reminders and promotions'),
            value: appState.notificationsEnabled,
            onChanged: (v) => context.read<AppState>().setNotifications(v),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          _SectionHeader('Language'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: appState.language,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Spanish', child: Text('Español')),
                DropdownMenuItem(value: 'French', child: Text('Français')),
              ],
              onChanged: (v) {
                if (v != null) context.read<AppState>().setLanguage(v);
              },
            ),
          ),
          _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About StyleBook'),
            subtitle: const Text('Version 1.0.0'),
          ),
          _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: const Text(
              'Clear All Data',
              style: TextStyle(color: AppColors.error),
            ),
            subtitle: const Text('Remove all app data and reset settings'),
            onTap: () => _showClearConfirm(context),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

void _showClearConfirm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Clear All Data?'),
      content: const Text(
        'This will permanently delete all your bookings, favorites, and settings. This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            context.read<AppState>().clearAllData();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Clear All'),
        ),
      ],
    ),
  );
}
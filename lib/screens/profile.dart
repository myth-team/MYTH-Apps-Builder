import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylebook_salon_app/providers/app_state.dart';
import 'package:stylebook_salon_app/utils/colors.dart'; 
import 'package:stylebook_salon_app/widgets/stylist_avatar.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favorites = appState.favoriteStylists;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ProfileHeader(),
            const SizedBox(height: 24),
            _MembershipCard(),
            const SizedBox(height: 24),
            _FavoritesSection(favorites: favorites),
            const SizedBox(height: 24),
            _ReviewsSection(),
            const SizedBox(height: 24),
            _NotificationToggle(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Column(
      children: [
        Stack(
          children: [
            StylistAvatar(
              name: appState.userName,
              size: 100,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  onPressed: () => _showEditSheet(context),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          appState.userName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          appState.userPhone.isEmpty ? 'Add phone number' : appState.userPhone,
          style: TextStyle(
            color: appState.userPhone.isEmpty
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () => _showEditSheet(context),
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    final appState = context.read<AppState>();
    final nameCtrl = TextEditingController(text: appState.userName);
    final phoneCtrl = TextEditingController(text: appState.userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  appState.updateProfile(nameCtrl.text, phoneCtrl.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tier = context.watch<AppState>().membershipTier;

    Color tierColor;
    switch (tier) {
      case 'Gold':
        tierColor = const Color(0xFFFFD700);
        break;
      case 'Platinum':
        tierColor = const Color(0xFFE5E4E2);
        break;
      default:
        tierColor = const Color(0xFFC0C0C0);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tierColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.star, color: tierColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Membership',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    '$tier Member',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Benefits'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesSection extends StatelessWidget {
  final List<Stylist> favorites;

  const _FavoritesSection({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Favorite Stylists',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (favorites.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.favorite_border, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Text(
                    'No favorites yet',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          )
        else
          ...favorites.take(3).map((s) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: StylistAvatar(
                    name: s.name,
                    imageUrl: s.imageUrl,
                    size: 48,
                  ),
                  title: Text(s.name),
                  subtitle: Text(s.specialties.take(2).join(' • ')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/stylist_detail',
                    arguments: s.id,
                  ),
                ),
              )),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Reviews',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.rate_review_outlined, color: AppColors.textSecondary),
                SizedBox(width: 12),
                Text(
                  'No reviews yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enabled = context.watch<AppState>().notificationsEnabled;

    return Card(
      child: SwitchListTile(
        title: const Text('Push Notifications'),
        subtitle: const Text('Reminders and booking updates'),
        value: enabled,
        onChanged: (v) => context.read<AppState>().setNotifications(v),
        secondary: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
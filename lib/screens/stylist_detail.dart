import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylebook_salon_app/providers/app_state.dart';
import 'package:stylebook_salon_app/utils/colors.dart'; 
import 'package:stylebook_salon_app/widgets/stylist_avatar.dart'; 

class StylistDetailScreen extends StatelessWidget {
  const StylistDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stylistId = ModalRoute.of(context)!.settings.arguments as String;
    final stylist = context.read<AppState>().stylists.firstWhere((s) => s.id == stylistId);
    final isFavorite = context.watch<AppState>().isFavorite(stylistId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: stylist.imageUrl != null
                  ? Image.network(
                      stylist.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.primaryLight,
                      child: Center(
                        child: StylistAvatar(name: stylist.name, size: 120),
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primary : Colors.white,
                ),
                onPressed: () => context.read<AppState>().toggleFavorite(stylistId),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stylist.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              stylist.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${stylist.reviewCount} reviews',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle('About'),
                  Text(
                    stylist.bio,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('Specialties'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: stylist.specialties.map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppColors.primaryLight,
                      labelStyle: const TextStyle(color: AppColors.primaryDark),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('Portfolio'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => _PortfolioItem(index: index),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('Recent Reviews'),
                  const SizedBox(height: 12),
                  _ReviewItem(
                    name: 'Jessica M.',
                    rating: 5,
                    comment: 'Amazing color work! Sarah really listened to what I wanted.',
                  ),
                  const Divider(),
                  _ReviewItem(
                    name: 'Michael T.',
                    rating: 5,
                    comment: 'Best haircut I\'ve had in years. Highly recommend!',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/booking_flow',
              arguments: stylist.id,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Book with ${stylist.name.split(' ').first}'),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  final int index;
  const _PortfolioItem({required this.index});

  static const List<String> urls = [
    'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=200',
    'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=200',
    'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?w=200',
    'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=200',
    'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=200',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        urls[index % urls.length],
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const _ReviewItem({
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StylistAvatar(name: name, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        size: 14,
                        color: AppColors.accent,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
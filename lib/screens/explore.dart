import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylebook_salon_app/providers/app_state.dart';
import 'package:stylebook_salon_app/utils/colors.dart'; 

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  final List<Map<String, String>> styles = const [
    {'name': 'Balayage', 'url': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=300'},
    {'name': 'Bob Cut', 'url': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300'},
    {'name': 'Curly', 'url': 'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?w=300'},
    {'name': 'Pixie', 'url': 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=300'},
    {'name': 'Updo', 'url': 'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=300'},
    {'name': 'Fade', 'url': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TrendingCarousel(),
            const SizedBox(height: 24),
            _SeasonalBanner(),
            const SizedBox(height: 24),
            Text(
              'Find by Style',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: styles.length,
              itemBuilder: (context, index) => _StyleGridItem(
                name: styles[index]['name']!,
                imageUrl: styles[index]['url']!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingCarousel extends StatelessWidget {
  final items = const [
    {'title': 'Glass Hair', 'subtitle': 'The sleek shine trend', 'color': 0xFFE91E63},
    {'title': 'Butterfly Cut', 'subtitle': 'Layers with movement', 'color': 0xFF9C27B0},
    {'title': 'Copper Glow', 'subtitle': 'Warm tones for fall', 'color': 0xFFFF5722},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Now',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(item['color'] as int),
                      Color(item['color'] as int).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item['title']! as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle']! as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SeasonalBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_offer, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summer Refresh Special',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '20% off color services through August',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _StyleGridItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _StyleGridItem({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AppState>().setHomeFilter(name);
      },
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
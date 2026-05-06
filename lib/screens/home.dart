import 'package:flutter/material.dart';
import 'package:styleme_salon_app/utils/colors.dart'; 
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    _HomeTab(),
    _ServicesTab(),
    _StylistsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.content_cut), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Stylists'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('StyleMe Salon', style: TextStyle(color: Colors.white)),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(Icons.content_cut, size: 80, color: Colors.white24),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/my_appointments'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuickBookCard(
                  onTap: () => Navigator.pushNamed(context, '/booking'),
                ),
                const SizedBox(height: 24),
                const Text('Featured Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _FeaturedServicesList(),
                const SizedBox(height: 24),
                const Text('Top Stylists', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _TopStylistsList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickBookCard extends StatelessWidget {
  final VoidCallback onTap;
  const _QuickBookCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Book', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Book your next appointment in seconds', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_forward, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedServicesList extends StatelessWidget {
  final List<_Service> services = [
    _Service(Icons.content_cut, 'Haircut', 'Professional cut & style', 35),
    _Service(Icons.face, 'Coloring', 'Full color & highlights', 85),
    _Service(Icons.spa, 'Treatment', 'Deep conditioning', 45),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = services[index];
          return _ServiceCard(service: s, onTap: () => Navigator.pushNamed(context, '/booking'));
        },
      ),
    );
  }
}

class _Service {
  final IconData icon;
  final String name;
  final String desc;
  final double price;
  const _Service(this.icon, this.name, this.desc, this.price);
}

class _ServiceCard extends StatelessWidget {
  final _Service service;
  final VoidCallback onTap;
  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(service.icon, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(service.desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Text('\$${service.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StylistsList extends StatelessWidget {
  final List<_Stylist> stylists = [
    _Stylist('Sarah', 'Color Specialist', 4.9, 'https://i.pravatar.cc/150?img=1'),
    _Stylist('Mike', 'Cut Expert', 4.8, 'https://i.pravatar.cc/150?img=3'),
    _Stylist('Lisa', 'Styling Pro', 4.7, 'https://i.pravatar.cc/150?img=5'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stylists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = stylists[index];
          return _StylistChip(stylist: s, onTap: () => Navigator.pushNamed(context, '/stylists'));
        },
      ),
    );
  }
}

class _Stylist {
  final String name;
  final String specialty;
  final double rating;
  final String avatar;
  const _Stylist(this.name, this.specialty, this.rating, this.avatar);
}

class _StylistChip extends StatelessWidget {
  final _Stylist stylist;
  final VoidCallback onTap;
  const _StylistChip({required this.stylist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(stylist.avatar),
              ),
              const SizedBox(height: 8),
              Text(stylist.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.starFilled),
                  Text(' ${stylist.rating}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceData('Haircut', 'Professional cut & style', 35, Icons.content_cut),
      _ServiceData('Hair Coloring', 'Full color & highlights', 85, Icons.palette),
      _ServiceData('Hair Treatment', 'Deep conditioning & repair', 45, Icons.spa),
      _ServiceData('Blow Dry', 'Professional blowout', 30, Icons.air),
      _ServiceData('Bridal Styling', 'Wedding & event styling', 120, Icons.card_giftcard),
      _ServiceData('Highlights', 'Partial & full highlights', 75, Icons.auto_awesome),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Services'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (ctx, i) => _ServiceTile(service: services[i], onTap: () => Navigator.pushNamed(context, '/booking')),
      ),
    );
  }
}

class _ServiceData {
  final String name;
  final String desc;
  final double price;
  final IconData icon;
  const _ServiceData(this.name, this.desc, this.price, this.icon);
}

class _ServiceTile extends StatelessWidget {
  final _ServiceData service;
  final VoidCallback onTap;
  const _ServiceTile({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(service.icon, color: AppColors.primary),
        ),
        title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(service.desc),
        trailing: Text('\$${service.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
      ),
    );
  }
}

class _StylistsTab extends StatelessWidget {
  const _StylistsTab();

  @override
  Widget build(BuildContext context) {
    final stylists = [
      _StylistData('Sarah Johnson', 'Color Specialist', 4.9, 'Expert in vibrant colors and balayage', 'https://i.pravatar.cc/150?img=1'),
      _StylistData('Mike Chen', 'Cut Expert', 4.8, 'Precision cuts for men and women', 'https://i.pravatar.cc/150?img=3'),
      _StylistData('Lisa Park', 'Styling Pro', 4.7, 'Bridal and event styling specialist', 'https://i.pravatar.cc/150?img=5'),
      _StylistData('James Wilson', 'Texture Expert', 4.6, 'Curly and textured hair specialist', 'https://i.pravatar.cc/150?img=7'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Stylists'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
        itemCount: stylists.length,
        itemBuilder: (ctx, i) => _StylistCard(stylist: stylists[i], onTap: () => Navigator.pushNamed(context, '/stylists')),
      ),
    );
  }
}

class _StylistData {
  final String name;
  final String specialty;
  final double rating;
  final String bio;
  final String avatar;
  const _StylistData(this.name, this.specialty, this.rating, this.bio, this.avatar);
}

class _StylistCard extends StatelessWidget {
  final _StylistData stylist;
  final VoidCallback onTap;
  const _StylistCard({required this.stylist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 40, backgroundImage: NetworkImage(stylist.avatar)),
              const SizedBox(height: 12),
              Text(stylist.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
              Text(stylist.specialty, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.star, size: 18, color: AppColors.starFilled),
                Text(' ${stylist.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
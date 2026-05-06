import 'package:flutter/material.dart';
import 'package:styleme_salon_app/utils/colors.dart'; 

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceItem('Haircut', 'Professional cut & style', 35, Icons.content_cut),
      _ServiceItem('Hair Coloring', 'Full color & highlights', 85, Icons.palette),
      _ServiceItem('Hair Treatment', 'Deep conditioning & repair', 45, Icons.spa),
      _ServiceItem('Blow Dry', 'Professional blowout', 30, Icons.air),
      _ServiceItem('Bridal Styling', 'Wedding & event styling', 120, Icons.card_giftcard),
      _ServiceItem('Highlights', 'Partial & full highlights', 75, Icons.auto_awesome),
      _ServiceItem('Deep Conditioning', 'Intensive moisture treatment', 40, Icons.water_drop),
      _ServiceItem('Keratin Treatment', 'Smoothing & straightening', 150, Icons.waves),
      _ServiceItem('Men\'s Cut', 'Classic & modern men\'s cuts', 25, Icons.face),
      _ServiceItem('Kids Cut', 'Gentle cuts for children', 20, Icons.child_care),
      _ServiceItem('Scalp Treatment', 'Healthy scalp services', 55, Icons.healing),
      _ServiceItem('Event Styling', 'Special occasion styling', 90, Icons.celebration),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (ctx, i) => _ServiceCard(service: services[i], onTap: () => Navigator.pushNamed(context, '/booking')),
      ),
    );
  }
}

class _ServiceItem {
  final String name;
  final String desc;
  final double price;
  final IconData icon;
  const _ServiceItem(this.name, this.desc, this.price, this.icon);
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem service;
  final VoidCallback onTap;
  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service.icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(service.desc, style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('\$${service.price.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
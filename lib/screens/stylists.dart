import 'package:flutter/material.dart';
import 'package:styleme_salon_app/utils/colors.dart'; 
import 'package:intl/intl.dart';

class StylistsScreen extends StatelessWidget {
  const StylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stylists = [
      _StylistData('Sarah Johnson', 'Color Specialist', 4.9, 'Expert in vibrant colors and balayage. 10+ years experience.', 'https://i.pravatar.cc/150?img=1'),
      _StylistData('Mike Chen', 'Cut Expert', 4.8, 'Precision cuts for men and women. Known for modern layered styles.', 'https://i.pravatar.cc/150?img=3'),
      _StylistData('Lisa Park', 'Styling Pro', 4.7, 'Bridal and event styling specialist. Featured in Style Magazine.', 'https://i.pravatar.cc/150?img=5'),
      _StylistData('James Wilson', 'Texture Expert', 4.6, 'Curly and textured hair specialist. Natural hair care advocate.', 'https://i.pravatar.cc/150?img=7'),
      _StylistData('Emma Davis', 'Color Artist', 4.9, 'Specializes in fantasy colors and creative highlights.', 'https://i.pravatar.cc/150?img=9'),
      _StylistData('Tom Brown', 'Men\'s Grooming', 4.5, 'Classic cuts and beard styling for the modern gentleman.', 'https://i.pravatar.cc/150?img=11'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Stylists'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
        itemCount: stylists.length,
        itemBuilder: (ctx, i) => _StylistGridCard(stylist: stylists[i], onTap: () => _showStylistDetail(context, stylists[i])),
      ),
    );
  }

  void _showStylistDetail(BuildContext context, _StylistData stylist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _StylistDetailSheet(stylist: stylist),
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

class _StylistGridCard extends StatelessWidget {
  final _StylistData stylist;
  final VoidCallback onTap;
  const _StylistGridCard({required this.stylist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 45, backgroundImage: NetworkImage(stylist.avatar)),
              const SizedBox(height: 12),
              Text(stylist.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(stylist.specialty, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.star, size: 18, color: AppColors.starFilled),
                const SizedBox(width: 4),
                Text(stylist.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _StylistDetailSheet extends StatefulWidget {
  final _StylistData stylist;
  const _StylistDetailSheet({required this.stylist});

  @override
  State<_StylistDetailSheet> createState() => _StylistDetailSheetState();
}

class _StylistDetailSheetState extends State<_StylistDetailSheet> {
  DateTime? selectedDate;
  String? selectedTime;

  final List<String> timeSlots = ['9:00 AM', '10:00 AM', '11:00 AM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              CircleAvatar(radius: 60, backgroundImage: NetworkImage(widget.stylist.avatar)),
              const SizedBox(height: 16),
              Text(widget.stylist.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(widget.stylist.specialty, style: const TextStyle(color: AppColors.primary, fontSize: 16)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.star, color: AppColors.starFilled, size: 24),
                const SizedBox(width: 4),
                Text(widget.stylist.rating.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 20),
              Text(widget.stylist.bio, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              const Text('Select Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 14,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final date = DateTime.now().add(Duration(days: i));
                    final isSelected = selectedDate?.day == date.day && selectedDate?.month == date.month;
                    return _DateChip(date: date, isSelected: isSelected, onTap: () => setState(() => selectedDate = date));
                  },
                ),
              ),
              if (selectedDate != null) ...[
                const SizedBox(height: 24),
                const Text('Select Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: timeSlots.map((t) => _TimeChip(time: t, isSelected: selectedTime == t, onTap: () => setState(() => selectedTime = t))).toList(),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedDate != null && selectedTime != null ? () => Navigator.pushNamed(context, '/booking') : null,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Book Appointment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  const _DateChip({required this.date, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('EEE').format(date), style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.textSecondary)),
            Text(date.day.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;
  const _TimeChip({required this.time, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
        ),
        child: Text(time, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
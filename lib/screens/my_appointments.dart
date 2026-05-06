import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styleme_salon_app/utils/colors.dart'; 

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _allAppointments = [
    {'id': 1, 'service': 'Haircut & Style', 'stylist': 'Sarah Miller', 'date': DateTime.now().add(const Duration(days: 2)), 'time': '10:00 AM', 'status': 'upcoming', 'price': 45.0},
    {'id': 2, 'service': 'Hair Coloring', 'stylist': 'Emily Chen', 'date': DateTime.now().add(const Duration(days: 5)), 'time': '2:00 PM', 'status': 'upcoming', 'price': 120.0},
    {'id': 3, 'service': 'Blow Dry', 'stylist': 'James Wilson', 'date': DateTime.now().subtract(const Duration(days: 3)), 'time': '11:30 AM', 'status': 'completed', 'price': 35.0},
    {'id': 4, 'service': 'Deep Conditioning', 'stylist': 'Mike Brown', 'date': DateTime.now().subtract(const Duration(days: 10)), 'time': '3:00 PM', 'status': 'completed', 'price': 40.0},
    {'id': 5, 'service': 'Highlights', 'stylist': 'Sarah Miller', 'date': DateTime.now().subtract(const Duration(days: 20)), 'time': '9:00 AM', 'status': 'cancelled', 'price': 150.0},
  ];

  List<Map<String, dynamic>> get _upcomingAppointments =>
      _allAppointments.where((a) => a['status'] == 'upcoming').toList();

  List<Map<String, dynamic>> get _pastAppointments =>
      _allAppointments.where((a) => a['status'] != 'upcoming').toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _cancelAppointment(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: Text('Are you sure you want to cancel your ${appointment['service']} appointment with ${appointment['stylist']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                appointment['status'] = 'cancelled';
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment cancelled'), backgroundColor: AppColors.error),
              );
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.accent,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(_upcomingAppointments, isUpcoming: true),
          _buildAppointmentList(_pastAppointments, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(List<Map<String, dynamic>> appointments, {required bool isUpcoming}) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isUpcoming ? Icons.calendar_today : Icons.history, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming appointments' : 'No past appointments',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/booking'),
                icon: const Icon(Icons.add),
                label: const Text('Book Now'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _AppointmentCard(
          appointment: appointment,
          isUpcoming: isUpcoming,
          onCancel: isUpcoming ? () => _cancelAppointment(appointment) : null,
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final bool isUpcoming;
  final VoidCallback? onCancel;

  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
    this.onCancel,
  });

  Color get _statusColor {
    switch (appointment['status']) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  String get _statusText {
    switch (appointment['status']) {
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Confirmed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment['service'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusText,
                    style: TextStyle(color: _statusColor, fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(appointment['stylist'], style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat.yMMMd().format(appointment['date'])} at ${appointment['time']}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${appointment['price'].toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                ),
                if (isUpcoming && onCancel != null)
                  TextButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Cancel'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
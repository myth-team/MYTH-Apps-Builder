import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _surgeEnabled = false;
  double _surgeMultiplier = 1.0;
  String _searchQuery = '';

  final _mockUsers = [
    ('John Doe', 'Passenger', false),
    ('Jane Smith', 'Driver', false),
    ('Mike Johnson', 'Driver', true),
  ];

  List<dynamic> get _filteredUsers {
    if (_searchQuery.isEmpty) return _mockUsers;
    return _mockUsers.where((u) => u.$1.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Panel', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            SizedBox(height: 16),
            _buildSurgeControl(),
            SizedBox(height: 16),
            _buildSearchBar(),
            SizedBox(height: 8),
            Text('Users & Drivers', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            ..._filteredUsers.map((user) => _buildUserTile(user.$1, user.$2, user.$3)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final stats = [
      ('Users', '1,248', Icons.people, AppColors.primary),
      ('Drivers', '342', Icons.local_taxi, AppColors.secondary),
      ('Active Trips', '89', Icons.navigation, AppColors.accent),
    ];

    return Row(
      children: stats.map((s) => Expanded(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(s.$3, color: s.$4, size: 28),
                SizedBox(height: 8),
                Text(s.$2, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                SizedBox(height: 4),
                Text(s.$1, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildSurgeControl() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Surge Pricing', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                Switch(
                  value: _surgeEnabled,
                  onChanged: (v) => setState(() => _surgeEnabled = v),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            if (_surgeEnabled) ...[
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Multiplier', style: TextStyle(color: AppColors.textSecondary)),
                  Text('${_surgeMultiplier.toStringAsFixed(1)}x', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
              Slider(
                value: _surgeMultiplier,
                min: 1.0,
                max: 3.0,
                divisions: 20,
                onChanged: (v) => setState(() => _surgeMultiplier = v),
                activeColor: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (v) => setState(() => _searchQuery = v),
      decoration: InputDecoration(
        hintText: 'Search users or drivers...',
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  Widget _buildUserTile(String name, String role, bool suspended) {
    final isDriver = role == 'Driver';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDriver ? AppColors.secondary : AppColors.primary,
          child: Text(name[0], style: TextStyle(color: Colors.white)),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('$role${suspended ? ' • Suspended' : ''}', style: TextStyle(
          fontSize: 12,
          color: suspended ? AppColors.error : AppColors.textSecondary,
        )),
        trailing: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: suspended ? AppColors.success : AppColors.error,
          ),
          child: Text(suspended ? 'Reinstate' : 'Suspend'),
        ),
      ),
    );
  }
}
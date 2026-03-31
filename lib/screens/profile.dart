import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prompt_reader_pro_app/utils/colors.dart'; 

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 48),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(Icons.person, color: AppColors.backgroundColor, size: 50),
            ),
            SizedBox(height: 16),
            Text(
              'Shahab Hassan',
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Pro Member',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('142', 'Prompts'),
                  Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                  _buildStat('28', 'Saved'),
                  Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                  _buildStat('Pro', 'Plan'),
                ],
              ),
            ),
            SizedBox(height: 32),
            _buildSection('Account', [
              _buildMenuItem(Icons.person, 'Edit Profile', () {}),
              _buildMenuItem(Icons.workspace_premium, 'Subscription', () {}),
              _buildMenuItem(Icons.security, 'Privacy & Security', () {}),
            ]),
            SizedBox(height: 24),
            _buildSection('Preferences', [
              _buildMenuItem(Icons.notifications, 'Notifications', () {}),
              _buildMenuItem(Icons.palette, 'Appearance', () {}),
              _buildMenuItem(Icons.language, 'Language', () {}),
            ]),
            SizedBox(height: 24),
            _buildSection('Support', [
              _buildMenuItem(Icons.help, 'Help Center', () {}),
              _buildMenuItem(Icons.feedback, 'Send Feedback', () {}),
              _buildMenuItem(Icons.info, 'About', () {}),
            ]),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 22),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prompt_reader_pro_app/utils/colors.dart'; 
import 'package:prompt_reader_pro_app/screens/browse.dart'; 
import 'package:prompt_reader_pro_app/screens/saved.dart'; 
import 'package:prompt_reader_pro_app/screens/profile.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    BrowseScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          border: Border(
            top: BorderSide(color: AppColors.primaryColor.withOpacity(0.3), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Again,',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        'Shahab Hassan',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.cardColor,
                  child: Icon(Icons.person, color: AppColors.primaryColor, size: 32),
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor.withOpacity(0.2), AppColors.cardColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.5), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'MYTH AI Assistant',
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe what you want to build...',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                    style: GoogleFonts.poppins(color: AppColors.textColor),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'MYTH v1.0',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: AppColors.primaryColor, size: 20),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Icon(Icons.send, color: AppColors.backgroundColor, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildQuickAction(Icons.copy, 'Copy', 'Last prompt')),
                SizedBox(width: 12),
                Expanded(child: _buildQuickAction(Icons.history, 'History', '30 prompts')),
                SizedBox(width: 12),
                Expanded(child: _buildQuickAction(Icons.star, 'Favorite', '5 saved')),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Trending Categories',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryCard('Business', Icons.business, '124 prompts'),
                  _buildCategoryCard('Coding', Icons.code, '98 prompts'),
                  _buildCategoryCard('Creative', Icons.palette, '156 prompts'),
                  _buildCategoryCard('Marketing', Icons.campaign, '87 prompts'),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Example Prompts',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            _buildExampleCard('Build a finance dashboard with charts', 'Business'),
            _buildExampleCard('Create a fitness tracking app UI', 'Fitness'),
            _buildExampleCard('Design an ecommerce checkout flow', 'E-commerce'),
            _buildExampleCard('Write a product description generator', 'Marketing'),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 28),
          SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, String count) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                count,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, String category) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.copy, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
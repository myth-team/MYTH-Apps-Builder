import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prompt_reader_pro_app/utils/colors.dart'; 

class BrowseScreen extends StatefulWidget {
  @override  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Business', 'Coding', 'Creative', 'Marketing', 'Education'];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Business', 'icon': Icons.business, 'count': 124, 'color': Colors.blue},
    {'name': 'Web Development', 'icon': Icons.web, 'count': 98, 'color': Colors.orange},
    {'name': 'Mobile Apps', 'icon': Icons.phone_android, 'count': 76, 'color': Colors.green},
    {'name': 'Marketing', 'icon': Icons.campaign, 'count': 89, 'color': Colors.purple},
    {'name': 'Creative Writing', 'icon': Icons.edit, 'count': 112, 'color': Colors.pink},
    {'name': 'Data Science', 'icon': Icons.analytics, 'count': 67, 'color': Colors.teal},
    {'name': 'Social Media', 'icon': Icons.share, 'count': 54, 'color': Colors.cyan},
    {'name': 'E-commerce', 'icon': Icons.shopping_cart, 'count': 83, 'color': Colors.amber},
  ];

  final List<Map<String, dynamic>> _trendingPrompts = [
    {'title': 'Build a SaaS landing page', 'category': 'Web Dev', 'uses': 2340, 'rating': 4.8},
    {'title': 'Create Instagram growth strategy', 'category': 'Marketing', 'uses': 1890, 'rating': 4.7},
    {'title': 'Design fitness tracking feature', 'category': 'Mobile', 'uses': 1650, 'rating': 4.9},
    {'title': 'Write cold email templates', 'category': 'Sales', 'uses': 2100, 'rating': 4.6},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 48),
            Text(
              'Browse Prompts',
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Explore our collection of AI prompts',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search prompts...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor : AppColors.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.poppins(
                          color: isSelected ? AppColors.backgroundColor : AppColors.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Categories',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: (category['color'] as Color).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(category['icon'], color: category['color'] as Color, size: 24),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['name'] as String,
                            style: GoogleFonts.poppins(
                              color: AppColors.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${category['count']} prompts',
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
              },
            ),
            SizedBox(height: 32),
            Text(
              'Trending Prompts',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _trendingPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _trendingPrompts[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '#${index + 1}',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prompt['title'] as String,
                              style: GoogleFonts.poppins(
                                color: AppColors.textColor,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    prompt['category'] as String,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.people, size: 12, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  '${prompt['uses']}',
                                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.star, size: 12, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  '${prompt['rating']}',
                                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prompt_reader_pro_app/utils/colors.dart'; 

class SavedScreen extends StatefulWidget {
  @override  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _savedPrompts = [
    {'title': 'Build a modern dashboard UI', 'category': 'Business', 'date': 'Dec 15, 2024', 'copied': 12},
    {'title': 'Create authentication flow', 'category': 'Coding', 'date': 'Dec 14, 2024', 'copied': 8},
    {'title': 'Design app onboarding screens', 'category': 'Mobile', 'date': 'Dec 13, 2024', 'copied': 15},
    {'title': 'Write engaging product copy', 'category': 'Marketing', 'date': 'Dec 12, 2024', 'copied': 6},
  ];

  final List<Map<String, dynamic>> _recentPrompts = [
    {'title': 'Build a fintech app wireframe', 'category': 'Business', 'date': 'Dec 15, 2024', 'time': '2:30 PM'},
    {'title': 'Create API documentation', 'category': 'Coding', 'date': 'Dec 15, 2024', 'time': '1:15 PM'},
    {'title': 'Design social media feed', 'category': 'Creative', 'date': 'Dec 14, 2024', 'time': '11:45 AM'},
    {'title': 'Write email campaign', 'category': 'Marketing', 'date': 'Dec 14, 2024', 'time': '10:00 AM'},
    {'title': 'Create workout tracker', 'category': 'Fitness', 'date': 'Dec 13, 2024', 'time': '4:20 PM'},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24, 56, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Collection',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your saved and recent prompts',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: AppColors.backgroundColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Saved'),
                Tab(text: 'History'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSavedList(),
                _buildHistoryList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24),
      itemCount: _savedPrompts.length,
      itemBuilder: (context, index) {
        final prompt = _savedPrompts[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prompt['title'] as String,
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.bookmark, color: AppColors.primaryColor),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      prompt['category'] as String,
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.copy, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${prompt['copied']} times',
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    prompt['date'] as String,
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.copy, size: 16),
                      label: Text('Copy'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.edit, size: 16),
                      label: Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24),
      itemCount: _recentPrompts.length,
      itemBuilder: (context, index) {
        final prompt = _recentPrompts[index];
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
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.history, color: AppColors.primaryColor),
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
                        Text(
                          prompt['time'] as String,
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
    );
  }
}
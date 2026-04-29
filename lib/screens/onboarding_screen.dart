import 'package:flutter/material.dart';
import 'package:zee_luxury_jewels_app/utils/colors.dart'; 
import 'package:zee_luxury_jewels_app/screens/main_screen.dart'; 

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Timeless Elegance',
      'subtitle': 'Discover exquisite jewelry crafted with passion and precision by master artisans',
      'image': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600',
    },
    {
      'title': 'Rare Gemstones',
      'subtitle': 'Each piece features hand-selected gemstones of exceptional quality and beauty',
      'image': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600',
    },
    {
      'title': 'Bespoke Luxury',
      'subtitle': 'Experience personalized service and create your own unique masterpiece',
      'image': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=600',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _pages[index]['image']!,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.6),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _pages[index]['title']!,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: AppColors.pureWhite,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _pages[index]['subtitle']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.lightGray,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 8),
                      width: _currentPage == index ? 24 : 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primaryGold
                            : AppColors.lightGray.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'NEXT' : 'BEGIN',
                      style: TextStyle(
                        color: AppColors.deepBlack,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
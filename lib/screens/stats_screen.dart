import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:duel_duo_app/utils/colors.dart'; 

class StatsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recentMatches = [
    {'opponent': 'Alex', 'result': 'Win', 'score': '3-1', 'game': 'Doodle Fight'},
    {'opponent': 'Sam', 'result': 'Loss', 'score': '2-3', 'game': 'Reaction Duel'},
    {'opponent': 'Jordan', 'result': 'Win', 'score': '3-0', 'game': 'Same Brain'},
    {'opponent': 'Casey', 'result': 'Win', 'score': '3-2', 'game': 'Explain-Off'},
    {'opponent': 'Riley', 'result': 'Loss', 'score': '1-3', 'game': 'Doodle Fight'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              SizedBox(height: 24),
              Text(
                'Your Stats',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms),
              SizedBox(height: 32),
              // Stats cards
              _buildStatsOverview()
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 500.ms),
              SizedBox(height: 32),
              // Recent matches
              Expanded(
                child: _buildRecentMatches()
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Matches', '24', AppColors.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Wins', '16', AppColors.success),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Win %', '67%', AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatches() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Matches',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: recentMatches.length,
              itemBuilder: (context, index) {
                final match = recentMatches[index];
                final isWin = match['result'] == 'Win';
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isWin ? AppColors.success.withOpacity(0.3) : AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isWin ? AppColors.success.withOpacity(0.2) : AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isWin ? Icons.emoji_events : Icons.close,
                          color: isWin ? AppColors.success : AppColors.accent,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'vs ${match['opponent']}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              match['game'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            match['score'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isWin ? AppColors.success : AppColors.accent,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            match['result'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isWin ? AppColors.success : AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
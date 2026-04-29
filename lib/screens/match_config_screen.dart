import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:duel_duo_app/utils/colors.dart'; 
import 'package:duel_duo_app/screens/gameplay_screen.dart'; 

class MatchConfigScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final String player1Avatar;
  final String player2Avatar;

  MatchConfigScreen({
    required this.player1Name,
    required this.player2Name,
    required this.player1Avatar,
    required this.player2Avatar,
  });

  @override
  State<MatchConfigScreen> createState() => _MatchConfigScreenState();
}

class _MatchConfigScreenState extends State<MatchConfigScreen> {
  int _selectedRounds = 3; // Best of 3

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
                'Match Setup',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms),
              SizedBox(height: 8),
              Text(
                'Configure your duel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),
              SizedBox(height: 40),
              // Players preview
              _buildPlayersPreview()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms),
              SizedBox(height: 40),
              // Round selection
              _buildRoundSelection()
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms),
              Spacer(),
              // Start button
              _buildStartButton(context)
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),
              SizedBox(height: 32),
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

  Widget _buildPlayersPreview() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerPreview(
            widget.player1Name,
            widget.player1Avatar,
            AppColors.player1,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'VS',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          _buildPlayerPreview(
            widget.player2Name,
            widget.player2Avatar,
            AppColors.player2,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPreview(String name, String avatarUrl, Color color) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.person,
                color: color,
                size: 36,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildRoundSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Length',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRoundOption(
                  'Best of 3',
                  'First to 2 wins',
                  3,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildRoundOption(
                  'Best of 5',
                  'First to 3 wins',
                  5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundOption(String title, String subtitle, int rounds) {
    final isSelected = _selectedRounds == rounds;
    return GestureDetector(
      onTap: () => setState(() => _selectedRounds = rounds),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => GameplayScreen(
              player1Name: widget.player1Name,
              player2Name: widget.player2Name,
              player1Avatar: widget.player1Avatar,
              player2Avatar: widget.player2Avatar,
              bestOf: _selectedRounds,
              isLocalMode: true,
            ),
          ),
          (route) => route.isFirst,
        );
      },
      child: Container(
        width: 280,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports,
              size: 28,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              'Begin Duel!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
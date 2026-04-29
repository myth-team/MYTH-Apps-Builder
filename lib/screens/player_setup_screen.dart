import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:duel_duo_app/utils/colors.dart'; 
import 'package:duel_duo_app/screens/match_config_screen.dart'; 

class PlayerSetupScreen extends StatefulWidget {
  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _player1Controller = TextEditingController(text: 'Player 1');
  final TextEditingController _player2Controller = TextEditingController(text: 'Player 2');
  int _selectedAvatar1 = 0;
  int _selectedAvatar2 = 1;

  final List<String> _avatarUrls = [
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Aneka',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Zack',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Molly',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Leo',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Nina',
  ];

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

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
                'Player Setup',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms),
              SizedBox(height: 32),
              // Player 1 Section
              _buildPlayerSection(
                'Player 1',
                AppColors.player1,
                _player1Controller,
                _selectedAvatar1,
                (index) => setState(() => _selectedAvatar1 = index),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 500.ms),
              SizedBox(height: 28),
              // VS Divider
              _buildVsDivider()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms),
              SizedBox(height: 28),
              // Player 2 Section
              _buildPlayerSection(
                'Player 2',
                AppColors.player2,
                _player2Controller,
                _selectedAvatar2,
                (index) => setState(() => _selectedAvatar2 = index),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms),
              Spacer(),
              // Start Match Button
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

  Widget _buildPlayerSection(
    String label,
    Color color,
    TextEditingController controller,
    int selectedAvatar,
    Function(int) onAvatarSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Avatar selection
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _avatarUrls.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedAvatar;
                return GestureDetector(
                  onTap: () => onAvatarSelected(index),
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.2) : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        _avatarUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // Name input
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                ),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: color,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVsDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppColors.primary],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'VS',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MatchConfigScreen(
              player1Name: _player1Controller.text.isEmpty ? 'Player 1' : _player1Controller.text,
              player2Name: _player2Controller.text.isEmpty ? 'Player 2' : _player2Controller.text,
              player1Avatar: _avatarUrls[_selectedAvatar1],
              player2Avatar: _avatarUrls[_selectedAvatar2],
            ),
          ),
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
              Icons.play_arrow,
              size: 28,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              'Start Match',
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
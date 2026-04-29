import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:duel_duo_app/utils/colors.dart'; 
import 'package:duel_duo_app/screens/match_config_screen.dart'; 

class NearbyLobbyScreen extends StatefulWidget {
  final String roomCode;
  final bool isHost;

  NearbyLobbyScreen({
    required this.roomCode,
    required this.isHost,
  });

  @override
  State<NearbyLobbyScreen> createState() => _NearbyLobbyScreenState();
}

class _NearbyLobbyScreenState extends State<NearbyLobbyScreen> {
  bool isReady = false;
  bool otherPlayerReady = false;
  bool otherPlayerJoined = false;

  @override
  void initState() {
    super.initState();
    // Simulate other player joining after delay
    if (widget.isHost) {
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() => otherPlayerJoined = true);
        }
      });
    } else {
      setState(() => otherPlayerJoined = true);
    }
  }

  void _toggleReady() {
    setState(() => isReady = !isReady);
    
    // Simulate other player ready
    if (!otherPlayerReady) {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() => otherPlayerReady = true);
        }
      });
    }

    // Auto start when both ready
    if (isReady && otherPlayerReady) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MatchConfigScreen(
              player1Name: 'Player 1',
              player2Name: 'Player 2',
              player1Avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Host',
              player2Avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Guest',
            ),
          ),
        );
      });
    }
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
              // Room code display
              _buildRoomCodeDisplay()
                  .animate()
                  .fadeIn(duration: 400.ms),
              SizedBox(height: 40),
              // Players in lobby
              _buildPlayersList()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms),
              Spacer(),
              // Ready button
              _buildReadyButton()
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

  Widget _buildRoomCodeDisplay() {
    return Column(
      children: [
        Text(
          widget.isHost ? 'Your Room Code' : 'Joining Room',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.meeting_room,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                widget.roomCode,
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 8,
                ),
              ),
            ],
          ),
        ),
        if (widget.isHost) ...[
          SizedBox(height: 12),
          Text(
            'Share this code with your opponent',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlayersList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildPlayerSlot(
            'Player 1',
            'https://api.dicebear.com/7.x/avataaars/svg?seed=Host',
            AppColors.player1,
            true,
            widget.isHost ? isReady : otherPlayerReady,
            widget.isHost,
          ),
          SizedBox(height: 16),
          _buildPlayerSlot(
            'Player 2',
            'https://api.dicebear.com/7.x/avataaars/svg?seed=Guest',
            AppColors.player2,
            otherPlayerJoined,
            widget.isHost ? otherPlayerReady : isReady,
            !widget.isHost,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSlot(
    String name,
    String avatarUrl,
    Color color,
    bool isConnected,
    bool isReady,
    bool isMe,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isConnected ? AppColors.cardBg : AppColors.surfaceLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected ? color.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isConnected ? color.withOpacity(0.2) : AppColors.textMuted.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isConnected ? color : AppColors.textMuted.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: isConnected
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.person,
                        color: color,
                      ),
                    ),
                  )
                : Icon(
                    Icons.hourglass_empty,
                    color: AppColors.textMuted,
                  ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? name : 'Waiting...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isConnected ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isConnected
                            ? isReady ? AppColors.success : AppColors.warning
                            : AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      isConnected
                          ? isReady ? 'Ready' : 'Not Ready'
                          : 'Not connected',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isConnected
                            ? isReady ? AppColors.success : AppColors.warning
                            : AppColors.textMuted,
                      ),
                    ),
                    if (isMe) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'YOU',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyButton() {
    final canReady = otherPlayerJoined;
    final bothReady = isReady && otherPlayerReady;

    return GestureDetector(
      onTap: canReady && !bothReady ? _toggleReady : null,
      child: Container(
        width: 280,
        height: 64,
        decoration: BoxDecoration(
          gradient: bothReady
              ? LinearGradient(colors: [AppColors.success, AppColors.secondary])
              : isReady
                  ? LinearGradient(colors: [AppColors.warning, AppColors.warning.withOpacity(0.8)])
                  : canReady
                      ? LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd])
                      : LinearGradient(colors: [AppColors.textMuted, AppColors.textMuted]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: canReady && !bothReady
              ? [
                  BoxShadow(
                    color: (isReady ? AppColors.warning : AppColors.primary).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              bothReady
                  ? Icons.check_circle
                  : isReady
                      ? Icons.cancel
                      : Icons.check,
              size: 28,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              bothReady
                  ? 'Starting...'
                  : isReady
                      ? 'Not Ready'
                      : 'I\'m Ready',
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
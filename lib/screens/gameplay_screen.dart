import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:duel_duo_app/utils/colors.dart'; 
import 'package:duel_duo_app/screens/result_screen.dart'; 

class GameplayScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final String player1Avatar;
  final String player2Avatar;
  final int bestOf;
  final bool isLocalMode;

  GameplayScreen({
    required this.player1Name,
    required this.player2Name,
    required this.player1Avatar,
    required this.player2Avatar,
    required this.bestOf,
    required this.isLocalMode,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int scoreP1 = 0;
  int scoreP2 = 0;
  int currentRound = 1;
  String currentGame = '';
  bool showInstruction = true;
  bool isPlaying = false;
  bool showResult = false;
  String roundWinner = '';
  String aiReason = '';

  final List<Map<String, dynamic>> games = [
    {'name': 'Doodle Fight', 'icon': Icons.brush, 'color': AppColors.doodleFight, 'desc': 'Draw the prompt!'},
    {'name': 'Explain-Off', 'icon': Icons.chat_bubble, 'color': AppColors.explainOff, 'desc': 'Explain your best!'},
    {'name': 'Reaction Duel', 'icon': Icons.bolt, 'color': AppColors.reactionDuel, 'desc': 'Tap when green!'},
    {'name': 'Same Brain', 'icon': Icons.psychology, 'color': AppColors.sameBrain, 'desc': 'Think the same!'},
  ];

  final List<String> prompts = [
    'A cat riding a skateboard',
    'Your favorite food',
    'A haunted house',
    'An alien picnic',
    'A robot doing yoga',
    'Underwater city',
  ];

  String currentPrompt = '';

  @override
  void initState() {
    super.initState();
    _selectRandomGame();
  }

  void _selectRandomGame() {
    final random = Random();
    final game = games[random.nextInt(games.length)];
    currentGame = game['name'];
    currentPrompt = prompts[random.nextInt(prompts.length)];
    showInstruction = true;
    isPlaying = false;
    showResult = false;
  }

  void _startRound() {
    setState(() {
      showInstruction = false;
      isPlaying = true;
    });
  }

  void _simulateRound() {
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      
      final random = Random();
      final outcomes = ['p1', 'p2', 'draw'];
      final outcome = outcomes[random.nextInt(outcomes.length)];
      
      setState(() {
        showResult = true;
        isPlaying = false;
        
        if (outcome == 'p1') {
          roundWinner = widget.player1Name;
          scoreP1++;
          aiReason = 'More creative and relevant approach';
        } else if (outcome == 'p2') {
          roundWinner = widget.player2Name;
          scoreP2++;
          aiReason = 'Better execution and detail';
        } else {
          roundWinner = 'Draw';
          aiReason = 'Both responses were equally matched';
        }
      });

      final winsNeeded = (widget.bestOf ~/ 2) + 1;
      if (scoreP1 >= winsNeeded || scoreP2 >= winsNeeded) {
        Future.delayed(Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                player1Name: widget.player1Name,
                player2Name: widget.player2Name,
                player1Avatar: widget.player1Avatar,
                player2Avatar: widget.player2Avatar,
                scoreP1: scoreP1,
                scoreP2: scoreP2,
                winner: scoreP1 > scoreP2 ? widget.player1Name : widget.player2Name,
                aiReason: aiReason,
              ),
            ),
          );
        });
      }
    });
  }

  void _nextRound() {
    setState(() {
      currentRound++;
      _selectRandomGame();
    });
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
              _buildScoreBoard(),
              SizedBox(height: 20),
              Expanded(
                child: _buildGameArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerScore(widget.player1Name, scoreP1, AppColors.player1),
          Column(
            children: [
              Text(
                'ROUND',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$currentRound',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'of ${widget.bestOf}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          _buildPlayerScore(widget.player2Name, scoreP2, AppColors.player2),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String name, int score, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              name[0].toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '$score',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGameArea() {
    if (showInstruction) {
      return _buildInstructionScreen();
    } else if (isPlaying) {
      return _buildActiveGameplay();
    } else if (showResult) {
      return _buildRoundResult();
    }
    return SizedBox.shrink();
  }

  Widget _buildInstructionScreen() {
    final game = games.firstWhere((g) => g['name'] == currentGame, orElse: () => games[0]);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: (game['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: game['color'] as Color,
                width: 3,
              ),
            ),
            child: Icon(
              game['icon'] as IconData,
              size: 60,
              color: game['color'] as Color,
            ),
          )
              .animate()
              .scale(duration: 500.ms)
              .then()
              .shake(duration: 300.ms),
          SizedBox(height: 32),
          Text(
            currentGame,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms),
          SizedBox(height: 12),
          Text(
            game['desc'] as String,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms),
          if (currentGame == 'Doodle Fight' || currentGame == 'Explain-Off') ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'PROMPT',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '"$currentPrompt"',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms),
          ],
          SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              _startRound();
              _simulateRound();
            },
            child: Container(
              width: 240,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [game['color'] as Color, (game['color'] as Color).withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (game['color'] as Color).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Start Round!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildActiveGameplay() {
    if (currentGame == 'Doodle Fight') {
      return _buildDoodleFightGameplay();
    } else if (currentGame == 'Explain-Off') {
      return _buildExplainOffGameplay();
    } else if (currentGame == 'Reaction Duel') {
      return _buildReactionDuelGameplay();
    }
    return _buildSameBrainGameplay();
  }

  Widget _buildDoodleFightGameplay() {
    return Column(
      children: [
        Text(
          'Draw: "$currentPrompt"',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.doodleFight,
              width: 3,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.brush,
                  size: 48,
                  color: AppColors.doodleFight.withOpacity(0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'Drawing in progress...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        _buildTimerWidget(),
      ],
    );
  }

  Widget _buildExplainOffGameplay() {
    return Column(
      children: [
        Text(
          'Explain: "$currentPrompt"',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.explainOff,
              width: 2,
            ),
          ),
          child: TextField(
            maxLines: 5,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Type your explanation...',
              hintStyle: GoogleFonts.poppins(
                color: AppColors.textMuted,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 24),
        _buildTimerWidget(),
      ],
    );
  }

  Widget _buildReactionDuelGameplay() {
    return Column(
      children: [
        Text(
          'Wait for green...',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.reactionDuel,
          ),
        ),
        SizedBox(height: 40),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.reactionDuel.withOpacity(0.2),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: AppColors.reactionDuel,
              width: 4,
            ),
          ),
          child: Center(
            child: Text(
              'WAIT',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.reactionDuel,
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(begin: Offset(1, 1), end: Offset(1.1, 1.1), duration: 800.ms)
            .then()
            .scale(begin: Offset(1.1, 1.1), end: Offset(1, 1), duration: 800.ms),
      ],
    );
  }

  Widget _buildSameBrainGameplay() {
    return Column(
      children: [
        Text(
          'Think of the same answer!',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.sameBrain,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Prompt: "$currentPrompt"',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.sameBrain,
              width: 2,
            ),
          ),
          child: TextField(
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              hintText: 'Your answer...',
              hintStyle: GoogleFonts.poppins(
                color: AppColors.textMuted,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 24),
        _buildTimerWidget(),
      ],
    );
  }

  Widget _buildTimerWidget() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 3,
        ),
      ),
      child: Center(
        child: _CountdownTimer(),
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return false;
      if (_secondsLeft <= 0) return false;
      setState(() => _secondsLeft--);
      return _secondsLeft > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_secondsLeft',
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _secondsLeft < 10 ? AppColors.accent : AppColors.primary,
      ),
    );
  }
}

class IntTween extends Tween<int> {
  IntTween({required int begin, required int end}) : super(begin: begin, end: end);

  @override
  int lerp(double t) {
    return (begin! + (end! - begin!) * t).round();
  }
}
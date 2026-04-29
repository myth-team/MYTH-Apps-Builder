import 'package:flutter/material.dart';
import 'package:tic_tac_glow_app/utils/colors.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  int scoreX = 0;
  int scoreO = 0;
  bool gameOver = false;
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        gameOver = true;
        if (board[pattern[0]] == 'X') {
          scoreX++;
        } else {
          scoreO++;
        }
        _showWinDialog(board[pattern[0]]);
        return;
      }
    }

    if (!board.contains('')) {
      gameOver = true;
      _showDrawDialog();
    }
  }

  void _showWinDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Column(
            children: [
              Text(
                winner == 'X' ? '🎉' : '🎊',
                style: const TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 10),
              Text(
                'Player $winner Wins!',
                style: TextStyle(
                  color: winner == 'X' ? AppColors.xColor : AppColors.oColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              resetGame();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text('Play Again', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Column(
            children: [
              Text('🤝', style: TextStyle(fontSize: 50)),
              SizedBox(height: 10),
              Text(
                "It's a Draw!",
                style: TextStyle(color: AppColors.accent, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              resetGame();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text('Play Again', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
    });
    _controller.reset();
    _controller.forward();
  }

  void resetAll() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
      scoreX = 0;
      scoreO = 0;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildScoreBoard(),
              const SizedBox(height: 40),
              _buildTurnIndicator(),
              const SizedBox(height: 30),
              _buildGameBoard(),
              const SizedBox(height: 30),
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
      ).createShader(bounds),
      child: const Text(
        'TIC TAC GLOW',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 4,
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreItem('Player X', scoreX.toString(), AppColors.xColor),
          Container(
            width: 2,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          _buildScoreItem('Player O', scoreO.toString(), AppColors.oColor),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String score, Color color) {
    return Column(
      children: [
        Text(
          score,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTurnIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: BoxDecoration(
        color: currentPlayer == 'X' ? AppColors.xColor.withOpacity(0.2) : AppColors.oColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: currentPlayer == 'X' ? AppColors.xColor : AppColors.oColor,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentPlayer,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: currentPlayer == 'X' ? AppColors.xColor : AppColors.oColor,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "'s Turn",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return Expanded(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildCell(index),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    return GestureDetector(
      onTap: () {
        if (board[index] == '' && !gameOver) {
          setState(() {
            board[index] = currentPlayer;
            checkWinner();
            if (!gameOver) {
              currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
            }
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.surface,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: board[index] == 'X'
                ? Text(
                    'X',
                    key: const ValueKey('X'),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.xColor,
                      shadows: [
                        Shadow(
                          color: AppColors.xColor.withOpacity(0.8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  )
                : board[index] == 'O'
                    ? Text(
                        'O',
                        key: const ValueKey('O'),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: AppColors.oColor,
                          shadows: [
                            Shadow(
                              color: AppColors.oColor.withOpacity(0.8),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: resetGame,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceLight,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          icon: const Icon(Icons.refresh, color: AppColors.accent),
          label: const Text('New Game', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        ),
        const SizedBox(width: 15),
        ElevatedButton.icon(
          onPressed: resetAll,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          icon: const Icon(Icons.restart_alt, color: AppColors.secondary),
          label: const Text('Reset All', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        ),
      ],
    );
  }
}
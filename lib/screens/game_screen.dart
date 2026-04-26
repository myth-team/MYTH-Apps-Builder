import 'package:flutter/material.dart';
import 'package:tictactoeflutter_app/utils/colors.dart'; 

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String? winner;
  List<int>? winningLine;

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = null;
      winningLine = null;
    });
  }

  void _handleTap(int index) {
    if (board[index] != '' || winner != null) return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      final a = pattern[0];
      final b = pattern[1];
      final c = pattern[2];

      if (board[a] != '' && board[a] == board[b] && board[b] == board[c]) {
        winner = board[a];
        winningLine = pattern;
        return;
      }
    }

    if (!board.contains('')) {
      winner = 'Draw';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildScoreBoard(),
              const SizedBox(height: 40),
              _buildGameBoard(),
              const SizedBox(height: 40),
              _buildStatus(),
              const SizedBox(height: 30),
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'TIC TAC TOE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Modern Edition',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerScore('X', AppColors.xColor, !isXTurn && winner == null),
          Container(
            height: 50,
            width: 2,
            color: AppColors.gridLine,
          ),
          _buildPlayerScore('O', AppColors.oColor, isXTurn && winner == null),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String player, Color color, bool isActive) {
    return Column(
      children: [
        Text(
          'Player $player',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? color : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildGameBoard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
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
        itemBuilder: (context, index) {
          return _buildCell(index);
        },
      ),
    );
  }

  Widget _buildCell(int index) {
    final isWinningCell = winningLine != null && winningLine!.contains(index);

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isWinningCell 
              ? AppColors.winHighlight.withOpacity(0.2)
              : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isWinningCell ? AppColors.winHighlight : AppColors.gridLine,
            width: isWinningCell ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: board[index] == 'X' ? AppColors.xColor : AppColors.oColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    String status;
    Color color;

    if (winner == 'Draw') {
      status = "It's a Draw!";
      color = AppColors.textSecondary;
    } else if (winner != null) {
      status = 'Player $winner Wins!';
      color = winner == 'X' ? AppColors.xColor : AppColors.oColor;
    } else {
      status = isXTurn ? "Player X's Turn" : "Player O's Turn";
      color = isXTurn ? AppColors.xColor : AppColors.oColor;
    }

    return Text(
      status,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.refresh_rounded, size: 24),
          SizedBox(width: 8),
          Text(
            'New Game',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:new_project_app/models/game_state.dart'; 
import 'package:new_project_app/utils/colors.dart'; 

class GameDialog extends StatelessWidget {
  final GameResult result;
  final VoidCallback onPlayAgain;
  final VoidCallback onResetAll;

  const GameDialog({
    super.key,
    required this.result,
    required this.onPlayAgain,
    required this.onResetAll,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surface.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getBorderColor().withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _getBorderColor().withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 16),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildSubtitle(),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            _getBorderColor().withOpacity(0.3),
            _getBorderColor().withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _getBorderColor().withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _getIconSymbol(),
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: _getBorderColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _getTitleText(),
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _getBorderColor(),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      _getSubtitleText(),
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPlayAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBorderColor(),
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Play Again',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onResetAll,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Reset Scores',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBorderColor() {
    switch (result) {
      case GameResult.xWins:
        return AppColors.playerX;
      case GameResult.oWins:
        return AppColors.playerO;
      case GameResult.draw:
        return AppColors.draw;
      default:
        return AppColors.primary;
    }
  }

  String _getIconSymbol() {
    switch (result) {
      case GameResult.xWins:
        return 'X';
      case GameResult.oWins:
        return 'O';
      case GameResult.draw:
        return '=';
      default:
        return '?';
    }
  }

  String _getTitleText() {
    switch (result) {
      case GameResult.xWins:
        return 'X Wins!';
      case GameResult.oWins:
        return 'O Wins!';
      case GameResult.draw:
        return 'Draw!';
      default:
        return 'Game Over';
    }
  }

  String _getSubtitleText() {
    switch (result) {
      case GameResult.xWins:
        return 'Player X takes this round';
      case GameResult.oWins:
        return 'Player O takes this round';
      case GameResult.draw:
        return 'It\'s a tie! Nobody wins this round';
      default:
        return '';
    }
  }
}
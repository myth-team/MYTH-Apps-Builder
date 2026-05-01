import 'package:flutter/material.dart';
import 'package:new_project_app/models/game_state.dart'; 
import 'package:new_project_app/utils/colors.dart'; 

class ScoreBoard extends StatelessWidget {
  final Map<Player, int> scores;
  final Player currentPlayer;
  final GameResult result;

  const ScoreBoard({
    super.key,
    required this.scores,
    required this.currentPlayer,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerScore(Player.x),
          _buildDivider(),
          _buildTurnIndicator(),
          _buildDivider(),
          _buildPlayerScore(Player.o),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(Player player) {
    final isActive = !result.isGameOver && currentPlayer == player;
    final color = player == Player.x ? AppColors.playerX : AppColors.playerO;
    final score = scores[player] ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player == Player.x ? 'X' : 'O',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isActive ? color : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 60,
      color: AppColors.surfaceLight.withOpacity(0.3),
    );
  }

  Widget _buildTurnIndicator() {
    final isOngoing = result == GameResult.ongoing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOngoing) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                'Turn',
                key: ValueKey('turn_$currentPlayer'),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Container(
                key: ValueKey('indicator_$currentPlayer'),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentPlayer == Player.x
                      ? AppColors.playerX.withOpacity(0.2)
                      : AppColors.playerO.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentPlayer == Player.x ? 'X' : 'O',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: currentPlayer == Player.x
                        ? AppColors.playerX
                        : AppColors.playerO,
                  ),
                ),
              ),
            ),
          ] else ...[
            const Text(
              'Result',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getResultText(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getResultColor(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getResultText() {
    switch (result) {
      case GameResult.xWins:
        return 'X Wins';
      case GameResult.oWins:
        return 'O Wins';
      case GameResult.draw:
        return 'Draw';
      default:
        return '-';
    }
  }

  Color _getResultColor() {
    switch (result) {
      case GameResult.xWins:
        return AppColors.playerX;
      case GameResult.oWins:
        return AppColors.playerO;
      case GameResult.draw:
        return AppColors.draw;
      default:
        return AppColors.textMuted;
    }
  }
}
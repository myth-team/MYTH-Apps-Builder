import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/models/game_state.dart'; 
import 'package:tic_tac_toe_app/models/player.dart'; 
import 'package:tic_tac_toe_app/utils/colors.dart'; 

class ScoreBoard extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onResetGame;
  final VoidCallback onResetScores;

  const ScoreBoard({
    super.key,
    required this.gameState,
    required this.onResetGame,
    required this.onResetScores,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScores(),
          const SizedBox(height: 16),
          _buildTurnIndicator(),
          const SizedBox(height: 20),
          _buildGameStatus(),
          const SizedBox(height: 20),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildScores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPlayerScore(
          player: gameState.xPlayer,
          isActive: gameState.currentTurn == PlayerSymbol.x && !gameState.isGameOver,
        ),
        _buildDivider(),
        _buildPlayerScore(
          player: gameState.oPlayer,
          isActive: gameState.currentTurn == PlayerSymbol.o && !gameState.isGameOver,
        ),
      ],
    );
  }

  Widget _buildPlayerScore({required Player player, required bool isActive}) {
    final isX = player.symbol == PlayerSymbol.x;
    final color = isX ? AppColors.playerX : AppColors.playerO;
    final gradient = isX ? AppColors.playerXGradient : AppColors.playerOGradient;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: isActive ? gradient : null,
        color: isActive ? null : AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? null
            : Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.textLight : color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${player.wins}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: isActive ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 2,
      decoration: BoxDecoration(
        color: AppColors.gridLine,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildTurnIndicator() {
    if (gameState.isGameOver) {
      return const SizedBox.shrink();
    }

    final isX = gameState.currentTurn == PlayerSymbol.x;
    final color = isX ? AppColors.playerX : AppColors.playerO;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Player ${isX ? 'X' : 'O'}'s Turn",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameStatus() {
    if (!gameState.isGameOver) {
      return const SizedBox.shrink();
    }

    String message;
    Color color;
    IconData icon;

    switch (gameState.status) {
      case GameStatus.xWins:
        message = 'X Wins!';
        color = AppColors.playerX;
        icon = Icons.emoji_events;
        break;
      case GameStatus.oWins:
        message = 'O Wins!';
        color = AppColors.playerO;
        icon = Icons.emoji_events;
        break;
      case GameStatus.draw:
        message = "It's a Draw!";
        color = AppColors.draw;
        icon = Icons.handshake;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          label: 'New Game',
          icon: Icons.refresh,
          onPressed: onResetGame,
          isPrimary: true,
        ),
        const SizedBox(width: 12),
        _buildButton(
          label: 'Reset Scores',
          icon: Icons.restart_alt,
          onPressed: onResetScores,
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.primaryGradient : null,
            color: isPrimary ? null : AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(12),
            border: isPrimary
                ? null
                : Border.all(color: AppColors.gridLineDark, width: 1),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPrimary ? AppColors.textLight : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? AppColors.textLight : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
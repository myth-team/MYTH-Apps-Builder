import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/models/game_state.dart'; 
import 'package:tic_tac_toe_app/models/player.dart'; 
import 'package:tic_tac_toe_app/utils/colors.dart'; 
import 'package:tic_tac_toe_app/widgets/cell_widget.dart'; 

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final Function(int row, int col) onCellTap;
  final List<List<int>>? winningCombination;

  const GameBoard({
    super.key,
    required this.gameState,
    required this.onCellTap,
    this.winningCombination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.gridLine, width: 2),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final row = index ~/ 3;
            final col = index % 3;
            final symbol = gameState.board[row][col];
            final isWinningCell = _isWinningCell(row, col);

            return CellWidget(
              symbol: symbol,
              isWinningCell: isWinningCell,
              enabled: !gameState.isGameOver && symbol == null,
              onTap: () => onCellTap(row, col),
            );
          },
        ),
      ),
    );
  }

  bool _isWinningCell(int row, int col) {
    if (winningCombination == null) return false;
    for (final combination in winningCombination!) {
      if (combination[0] == row && combination[1] == col) {
        return true;
      }
    }
    return false;
  }

  static List<List<int>>? getWinningCombination(GameState state) {
    if (state.status == GameStatus.active) return null;

    final player = state.status == GameStatus.xWins ? PlayerSymbol.x : PlayerSymbol.o;
    
    for (final combination in GameState.winningCombinations) {
      final cell1 = state.board[combination[0][0]][combination[0][1]];
      final cell2 = state.board[combination[1][0]][combination[1][1]];
      final cell3 = state.board[combination[2][0]][combination[2][1]];

      if (cell1 == player && cell1 == cell2 && cell2 == cell3) {
        return combination;
      }
    }

    return null;
  }
}
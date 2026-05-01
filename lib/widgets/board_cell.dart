import 'package:flutter/material.dart';
import 'package:new_project_app/models/game_state.dart'; 
import 'package:new_project_app/utils/colors.dart'; 

class BoardCell extends StatelessWidget {
  final CellState cellState;
  final VoidCallback onTap;
  final bool isWinningCell;
  final bool isInteractive;

  const BoardCell({
    super.key,
    required this.cellState,
    required this.onTap,
    this.isWinningCell = false,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isInteractive && cellState == CellState.empty ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: cellState == CellState.empty
              ? AppColors.cellGradient
              : null,
          color: cellState == CellState.empty && !isInteractive
              ? AppColors.cellEmpty
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isWinningCell
                ? AppColors.win
                : AppColors.gridLine,
            width: isWinningCell ? 3 : 2,
          ),
          boxShadow: isWinningCell
              ? [
                  BoxShadow(
                    color: AppColors.win.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: _buildCellContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent() {
    if (cellState == CellState.empty) {
      return const SizedBox.shrink();
    }

    final isX = cellState == CellState.x;
    final color = isX ? AppColors.playerX : AppColors.playerO;
    final symbol = isX ? 'X' : 'O';

    return Container(
      key: ValueKey(cellState),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [
              Shadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/models/game_state.dart'; 
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/board_cell.dart'; 
import 'package:new_project_app/widgets/score_board.dart'; 
import 'package:new_project_app/widgets/game_dialog.dart'; 

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = GameState.initial();
  }

  void _handleCellTap(int index) {
    setState(() {
      _gameState = _gameState.makeMove(index);
    });

    if (_gameState.result.isGameOver) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showGameDialog();
        }
      });
    }
  }

  void _showGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameDialog(
        result: _gameState.result,
        onPlayAgain: () {
          Navigator.of(context).pop();
          setState(() {
            _gameState = _gameState.resetRound();
          });
        },
        onResetAll: () {
          Navigator.of(context).pop();
          setState(() {
            _gameState = _gameState.resetAll();
          });
        },
      ),
    );
  }

  void _resetRound() {
    setState(() {
      _gameState = _gameState.resetRound();
    });
  }

  void _resetAll() {
    setState(() {
      _gameState = _gameState.resetAll();
    });
  }

  List<int> _getWinningCells() {
    if (!_gameState.result.isGameOver || _gameState.result == GameResult.draw) {
      return [];
    }

    final winner = _gameState.result.winner;
    if (winner == null) return [];

    final board = _gameState.board;
    for (final combo in GameState.winCombinations) {
      final a = board[combo[0]];
      final b = board[combo[1]];
      final c = board[combo[2]];
      if (a != CellState.empty && a == b && b == c) {
        final cellState = winner == Player.x ? CellState.x : CellState.o;
        if (a == cellState) {
          return combo;
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final winningCells = _getWinningCells();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                ScoreBoard(
                  scores: _gameState.scores,
                  currentPlayer: _gameState.currentPlayer,
                  result: _gameState.result,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _buildGameBoard(winningCells),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _resetAll,
          icon: const Icon(
            Icons.refresh,
            color: AppColors.textSecondary,
          ),
          tooltip: 'Reset Scores',
        ),
      ],
    );
  }

  Widget _buildGameBoard(List<int> winningCells) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.boardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gridLine,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final isWinningCell = winningCells.contains(index);
          return BoardCell(
            cellState: _gameState.board[index],
            onTap: () => _handleCellTap(index),
            isWinningCell: isWinningCell,
            isInteractive: _gameState.result == GameResult.ongoing,
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _resetRound,
          icon: const Icon(Icons.replay),
          label: const Text('New Round'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
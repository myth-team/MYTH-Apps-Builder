import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe_app/models/game_state.dart'; 
import 'package:tic_tac_toe_app/widgets/game_board.dart'; 
import 'package:tic_tac_toe_app/widgets/score_board.dart'; 
import 'package:tic_tac_toe_app/utils/colors.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState.initial(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: MediaQuery.of(context).size.height > 700 ? 24 : 12,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGameBoardSection(context),
                        SizedBox(height: MediaQuery.of(context).size.height > 700 ? 32 : 20),
                        _buildScoreSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Text(
            'Tic Tac Toe',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoardSection(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        final winningCombination = GameBoard.getWinningCombination(gameState);
        
        return GameBoard(
          gameState: gameState,
          winningCombination: winningCombination,
          onCellTap: (row, col) {
            context.read<GameState>().makeMove(row, col);
          },
        );
      },
    );
  }

  Widget _buildScoreSection(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return ScoreBoard(
          gameState: gameState,
          onResetGame: () {
            context.read<GameState>().resetGame();
          },
          onResetScores: () {
            context.read<GameState>().resetScores();
          },
        );
      },
    );
  }
}
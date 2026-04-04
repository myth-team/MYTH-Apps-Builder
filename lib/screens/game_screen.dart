import 'package:flutter/material.dart';
import 'package:tictactoe_master_app/utils/colors.dart'; 

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  int scoreX = 0;
  int scoreO = 0;
  int draws = 0;
  bool gameOver = false;
  String winner = '';
  List<int> winningLine = [];

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
      winner = '';
      winningLine = [];
    });
  }

  void resetAll() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
      winner = '';
      winningLine = [];
      scoreX = 0;
      scoreO = 0;
      draws = 0;
    });
  }

  bool checkWinner(String player) {
    List<List<int>> lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var line in lines) {
      if (board[line[0]] == player &&
          board[line[1]] == player &&
          board[line[2]] == player) {
        winningLine = line;
        return true;
      }
    }
    return false;
  }

  void handleTap(int index) {
    if (board[index] != '' || gameOver) return;

    setState(() {
      board[index] = currentPlayer;

      if (checkWinner(currentPlayer)) {
        gameOver = true;
        winner = currentPlayer;
        if (currentPlayer == 'X') {
          scoreX++;
        } else {
          scoreO++;
        }
      } else if (!board.contains('')) {
        gameOver = true;
        winner = 'Draw';
        draws++;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  Widget buildCell(int index) {
    bool isWinningCell = winningLine.contains(index);
    Color cellColor = Colors.transparent;
    Color symbolColor = AppColors.textSecondary;

    if (board[index] == 'X') {
      symbolColor = AppColors.playerX;
      cellColor = isWinningCell ? AppColors.winHighlight.withOpacity(0.2) : Colors.white;
    } else if (board[index] == 'O') {
      symbolColor = AppColors.playerO;
      cellColor = isWinningCell ? AppColors.winHighlight.withOpacity(0.2) : Colors.white;
    } else {
      cellColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => handleTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isWinningCell ? AppColors.winHighlight : AppColors.gridLine,
            width: isWinningCell ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: symbolColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        ),
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: resetAll,
            icon: Icon(Icons.refresh, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreCard('Player X', scoreX, AppColors.playerX),
                  _buildScoreCard('Draws', draws, AppColors.textSecondary),
                  _buildScoreCard('Player O', scoreO, AppColors.playerO),
                ],
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (gameOver)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: winner == 'Draw'
                              ? AppColors.textSecondary.withOpacity(0.2)
                              : (winner == 'X' ? AppColors.playerX : AppColors.playerO).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          winner == 'Draw'
                              ? 'It\'s a Draw!'
                              : 'Player $winner Wins!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: winner == 'Draw'
                                ? AppColors.textSecondary
                                : (winner == 'X' ? AppColors.playerX : AppColors.playerO),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: (currentPlayer == 'X' ? AppColors.playerX : AppColors.playerO).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Player $currentPlayer\'s Turn',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: currentPlayer == 'X' ? AppColors.playerX : AppColors.playerO,
                          ),
                        ),
                      ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return buildCell(index);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'New Round',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
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

  Widget _buildScoreCard(String label, int score, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/utils/colors.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  bool _gameOver = false;
  String? _winner;
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  static const List<List<int>> _winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  void _handleTap(int index) {
    if (_board[index].isNotEmpty || _gameOver) return;
    setState(() {
      _board[index] = _currentPlayer;
      _checkWin();
      if (!_gameOver) {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  void _checkWin() {
    for (final pattern in _winPatterns) {
      final a = _board[pattern[0]];
      final b = _board[pattern[1]];
      final c = _board[pattern[2]];
      if (a.isNotEmpty && a == b && b == c) {
        _gameOver = true;
        _winner = a;
        if (a == 'X') _xWins++;
        else _oWins++;
        return;
      }
    }
    if (!_board.contains('')) {
      _gameOver = true;
      _winner = null;
      _draws++;
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _gameOver = false;
      _winner = null;
    });
  }

  void _resetAll() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _gameOver = false;
      _winner = null;
      _xWins = 0;
      _oWins = 0;
      _draws = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              _buildScoreBoard(),
              SizedBox(height: 32),
              _buildTurnIndicator(),
              SizedBox(height: 24),
              _buildGrid(),
              SizedBox(height: 24),
              _buildResetButton(),
              if (_gameOver) _buildOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Tic Tac Toe',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ScoreCard(label: 'X', score: _xWins, color: AppColors.xColor),
        _ScoreCard(label: 'O', score: _oWins, color: AppColors.oColor),
        _ScoreCard(label: 'Draw', score: _draws, color: AppColors.drawColor),
      ],
    );
  }

  Widget _buildTurnIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gridLine,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Turn: ',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            _currentPlayer,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _currentPlayer == 'X' ? AppColors.xColor : AppColors.oColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gridLine,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) => _buildCell(index),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    final value = _board[index];
    final isX = value == 'X';
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: value.isEmpty ? AppColors.background : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gridLine, width: 2),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isX ? AppColors.xColor : (value == 'O' ? AppColors.oColor : Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _resetGame,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('New Game', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        SizedBox(width: 16),
        OutlinedButton(
          onPressed: _resetAll,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: BorderSide(color: AppColors.textSecondary),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Reset All', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: _winner != null
            ? (_winner == 'X' ? AppColors.xColor : AppColors.oColor)
            : AppColors.drawColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _winner != null ? 'Player $_winner Wins!' : 'It\'s a Draw!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _winner != null ? '🎉 Congratulations!' : '🤝 Good game!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final Color color;

  const _ScoreCard({required this.label, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
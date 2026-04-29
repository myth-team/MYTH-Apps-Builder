import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tictac_vision_app/utils/colors.dart'; 

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;
  int xScore = 0;
  int oScore = 0;
  int draws = 0;
  List<int> winningLine = [];
  bool isAiMode = false;
  bool isAiThinking = false;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _winController;
  late Animation<double> _winAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _winController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _winAnimation = CurvedAnimation(
      parent: _winController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _winController.dispose();
    super.dispose();
  }

  void _makeMove(int index) {
    if (board[index] != '' || gameOver || isAiThinking) return;

    setState(() {
      board[index] = currentPlayer;
      if (_checkWinner()) {
        winner = currentPlayer;
        gameOver = true;
        if (currentPlayer == 'X') {
          xScore++;
        } else {
          oScore++;
        }
        _winController.forward();
      } else if (!board.contains('')) {
        gameOver = true;
        draws++;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (isAiMode && currentPlayer == 'O') {
          _aiMove();
        }
      }
    });
  }

  void _aiMove() {
    isAiThinking = true;
    Future.delayed(Duration(milliseconds: 600), () {
      if (!mounted) return;
      int bestMove = _findBestMove();
      setState(() {
        board[bestMove] = 'O';
        isAiThinking = false;
        if (_checkWinner()) {
          winner = 'O';
          gameOver = true;
          oScore++;
          _winController.forward();
        } else if (!board.contains('')) {
          gameOver = true;
          draws++;
        } else {
          currentPlayer = 'X';
        }
      });
    });
  }

  int _findBestMove() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        if (_checkWinnerFor('O')) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'X';
        if (_checkWinnerFor('X')) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    List<int> corners = [0, 2, 6, 8];
    List<int> availableCorners = corners.where((c) => board[c] == '').toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[Random().nextInt(availableCorners.length)];
    }
    if (board[4] == '') return 4;
    List<int> edges = [1, 3, 5, 7];
    List<int> availableEdges = edges.where((e) => board[e] == '').toList();
    if (availableEdges.isNotEmpty) {
      return availableEdges[Random().nextInt(availableEdges.length)];
    }
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') return i;
    }
    return 0;
  }

  bool _checkWinnerFor(String player) {
    List<List<int>> lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (var line in lines) {
      if (board[line[0]] == player && board[line[1]] == player && board[line[2]] == player) {
        return true;
      }
    }
    return false;
  }

  bool _checkWinner() {
    List<List<int>> lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (var line in lines) {
      if (board[line[0]] == currentPlayer && board[line[1]] == currentPlayer && board[line[2]] == currentPlayer) {
        winningLine = line;
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
      winningLine = [];
      isAiThinking = false;
      _winController.reset();
    });
  }

  void _resetScores() {
    setState(() {
      xScore = 0;
      oScore = 0;
      draws = 0;
      _resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildScoreBoard(),
            _buildGameModeToggle(),
            Expanded(
              child: Center(
                child: _buildGameBoard(),
              ),
            ),
            _buildStatusBar(),
            _buildControls(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'TICTAC VISION',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gridLine, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('X', xScore, AppColors.primary, AppColors.glowPrimary),
          _buildScoreItem('DRAW', draws, AppColors.textSecondary, Colors.transparent),
          _buildScoreItem('O', oScore, AppColors.secondary, AppColors.glowSecondary),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color, Color glowColor) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: glowColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Center(
            child: Text(
              label == 'DRAW' ? '—' : label,
              style: TextStyle(
                fontSize: label == 'DRAW' ? 20 : 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label == 'DRAW' ? 'Draws' : 'Wins',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGameModeToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isAiMode = false;
                  _resetScores();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: !isAiMode
                      ? LinearGradient(colors: [AppColors.primary, AppColors.accent])
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '2 PLAYERS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: !isAiMode ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isAiMode = true;
                  _resetScores();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isAiMode
                      ? LinearGradient(colors: [AppColors.secondary, AppColors.accent])
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'VS AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isAiMode ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return Container(
      width: 320,
      height: 320,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gridLine, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.08),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return _buildCell(index);
            },
          ),
          if (isAiThinking)
            Container(
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'AI Thinking...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    bool isWinningCell = winningLine.contains(index);
    bool isEmpty = board[index] == '';

    return GestureDetector(
      onTap: () => _makeMove(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        decoration: BoxDecoration(
          color: isWinningCell
              ? AppColors.winner.withOpacity(0.15)
              : isEmpty
                  ? AppColors.cardBg
                  : board[index] == 'X'
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isWinningCell
                ? AppColors.winner
                : isEmpty
                    ? AppColors.gridLine
                    : board[index] == 'X'
                        ? AppColors.primary.withOpacity(0.4)
                        : AppColors.secondary.withOpacity(0.4),
            width: isWinningCell ? 2.5 : 1.5,
          ),
          boxShadow: isWinningCell
              ? [
                  BoxShadow(
                    color: AppColors.winner.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: board[index] == ''
              ? AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: currentPlayer == 'X' ? _glowAnimation.value * 0.15 : _glowAnimation.value * 0.15,
                      child: Icon(
                        currentPlayer == 'X' ? Icons.close : Icons.circle_outlined,
                        size: 40,
                        color: currentPlayer == 'X' ? AppColors.primary : AppColors.secondary,
                      ),
                    );
                  },
                )
              : _buildMark(board[index], isWinningCell),
        ),
      ),
    );
  }

  Widget _buildMark(String mark, bool isWinning) {
    Color color = mark == 'X' ? AppColors.primary : AppColors.secondary;
    if (isWinning) color = AppColors.winner;

    return AnimatedBuilder(
      animation: _winAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isWinning ? _winAnimation.value : 1.0,
          child: mark == 'X'
              ? CustomPaint(
                  size: Size(50, 50),
                  painter: XPainter(color, isWinning ? 3.5 : 3),
                )
              : CustomPaint(
                  size: Size(50, 50),
                  painter: OPainter(color, isWinning ? 3.5 : 3),
                ),
        );
      },
    );
  }

  Widget _buildStatusBar() {
    String status;
    Color statusColor;

    if (gameOver) {
      if (winner != '') {
        status = '$winner WINS!';
        statusColor = AppColors.winner;
      } else {
        status = 'IT\'S A DRAW!';
        statusColor = AppColors.textSecondary;
      }
    } else {
      status = '$currentPlayer\'S TURN';
      statusColor = currentPlayer == 'X' ? AppColors.primary : AppColors.secondary;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!gameOver)
            Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: statusColor,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _resetGame,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.cardBg, AppColors.surface],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gridLine, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'NEW GAME',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: _resetScores,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.accentLight,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'RESET ALL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class XPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  XPainter(this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final padding = size.width * 0.22;

    canvas.drawLine(
      Offset(padding, padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(padding, size.height - padding),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  OPainter(this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.32,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter) => false;
}
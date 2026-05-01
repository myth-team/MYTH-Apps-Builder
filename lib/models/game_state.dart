enum Player {
  x,
  o;

  Player get opponent => this == Player.x ? Player.o : Player.x;
}

enum CellState {
  empty,
  x,
  o;

  static CellState fromPlayer(Player player) {
    return player == Player.x ? CellState.x : CellState.o;
  }

  Player? toPlayer() {
    switch (this) {
      case CellState.x:
        return Player.x;
      case CellState.o:
        return Player.o;
      case CellState.empty:
        return null;
    }
  }
}

enum GameResult {
  ongoing,
  xWins,
  oWins,
  draw;

  bool get isGameOver => this != GameResult.ongoing;

  Player? get winner {
    switch (this) {
      case GameResult.xWins:
        return Player.x;
      case GameResult.oWins:
        return Player.o;
      default:
        return null;
    }
  }
}

class GameState {
  final List<CellState> board;
  final Player currentPlayer;
  final Map<Player, int> scores;
  final GameResult result;

  static const List<List<int>> winCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  const GameState._({
    required this.board,
    required this.currentPlayer,
    required this.scores,
    required this.result,
  });

  factory GameState.initial() {
    return GameState._(
      board: List.filled(9, CellState.empty),
      currentPlayer: Player.x,
      scores: {Player.x: 0, Player.o: 0},
      result: GameResult.ongoing,
    );
  }

  GameState makeMove(int index) {
    if (index < 0 || index > 8 || board[index] != CellState.empty || result != GameResult.ongoing) {
      return this;
    }

    final newBoard = List<CellState>.from(board);
    newBoard[index] = CellState.fromPlayer(currentPlayer);

    final winner = _checkWinner(newBoard);
    final gameResult = winner != null
        ? (winner == Player.x ? GameResult.xWins : GameResult.oWins)
        : _checkDraw(newBoard)
            ? GameResult.draw
            : GameResult.ongoing;

    final newScores = Map<Player, int>.from(scores);
    if (winner != null) {
      newScores[winner] = (newScores[winner] ?? 0) + 1;
    }

    return GameState._(
      board: newBoard,
      currentPlayer: currentPlayer.opponent,
      scores: newScores,
      result: gameResult,
    );
  }

  Player? _checkWinner(List<CellState> board) {
    for (final combo in winCombinations) {
      final a = board[combo[0]];
      final b = board[combo[1]];
      final c = board[combo[2]];
      if (a != CellState.empty && a == b && b == c) {
        return a == CellState.x ? Player.x : Player.o;
      }
    }
    return null;
  }

  bool _checkDraw(List<CellState> board) {
    return board.every((cell) => cell != CellState.empty);
  }

  GameState resetRound() {
    return GameState._(
      board: List.filled(9, CellState.empty),
      currentPlayer: Player.x,
      scores: scores,
      result: GameResult.ongoing,
    );
  }

  GameState resetAll() {
    return GameState._(
      board: List.filled(9, CellState.empty),
      currentPlayer: Player.x,
      scores: {Player.x: 0, Player.o: 0},
      result: GameResult.ongoing,
    );
  }
}
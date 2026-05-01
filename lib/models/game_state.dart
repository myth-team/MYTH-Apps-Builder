import 'package:tic_tac_toe_app/models/player.dart'; 

enum GameStatus { active, xWins, oWins, draw }

class GameState {
  final List<List<PlayerSymbol?>> board;
  final PlayerSymbol currentTurn;
  final GameStatus status;
  final Player xPlayer;
  final Player oPlayer;

  const GameState({
    required this.board,
    required this.currentTurn,
    required this.status,
    required this.xPlayer,
    required this.oPlayer,
  });

  factory GameState.initial() {
    return GameState(
      board: List.generate(
        3,
        (_) => List<PlayerSymbol?>.filled(3, null),
      ),
      currentTurn: PlayerSymbol.x,
      status: GameStatus.active,
      xPlayer: const Player(symbol: PlayerSymbol.x, name: 'X', wins: 0),
      oPlayer: const Player(symbol: PlayerSymbol.o, name: 'O', wins: 0),
    );
  }

  GameState copyWith({
    List<List<PlayerSymbol?>>? board,
    PlayerSymbol? currentTurn,
    GameStatus? status,
    Player? xPlayer,
    Player? oPlayer,
  }) {
    return GameState(
      board: board ?? this.board,
      currentTurn: currentTurn ?? this.currentTurn,
      status: status ?? this.status,
      xPlayer: xPlayer ?? this.xPlayer,
      oPlayer: oPlayer ?? this.oPlayer,
    );
  }

  Player get currentPlayer {
    return currentTurn == PlayerSymbol.x ? xPlayer : oPlayer;
  }

  bool get isGameOver => status != GameStatus.active;

  bool isCellEmpty(int row, int col) {
    return board[row][col] == null;
  }

  static const List<List<List<int>>> winningCombinations = [
    // Rows
    [[0, 0], [0, 1], [0, 2]],
    [[1, 0], [1, 1], [1, 2]],
    [[2, 0], [2, 1], [2, 2]],
    // Columns
    [[0, 0], [1, 0], [2, 0]],
    [[0, 1], [1, 1], [2, 1]],
    [[0, 2], [1, 2], [2, 2]],
    // Diagonals
    [[0, 0], [1, 1], [2, 2]],
    [[0, 2], [1, 1], [2, 0]],
  ];

  GameState makeMove(int row, int col) {
    if (!isCellEmpty(row, col) || isGameOver) {
      return this;
    }

    final newBoard = board.map((r) => List<PlayerSymbol?>.from(r)).toList();
    newBoard[row][col] = currentTurn;

    final newStatus = _checkWinner(newBoard, currentTurn);
    final nextTurn = currentTurn == PlayerSymbol.x ? PlayerSymbol.o : PlayerSymbol.x;

    Player? newXPlayer = xPlayer;
    Player? newOPlayer = oPlayer;

    if (newStatus == GameStatus.xWins) {
      newXPlayer = xPlayer.copyWith(wins: xPlayer.wins + 1);
    } else if (newStatus == GameStatus.oWins) {
      newOPlayer = oPlayer.copyWith(wins: oPlayer.wins + 1);
    }

    return GameState(
      board: newBoard,
      currentTurn: newStatus == GameStatus.active ? nextTurn : currentTurn,
      status: newStatus,
      xPlayer: newXPlayer,
      oPlayer: newOPlayer,
    );
  }

  GameStatus _checkWinner(List<List<PlayerSymbol?>> board, PlayerSymbol lastPlayer) {
    for (final combination in winningCombinations) {
      final cell1 = board[combination[0][0]][combination[0][1]];
      final cell2 = board[combination[1][0]][combination[1][1]];
      final cell3 = board[combination[2][0]][combination[2][1]];

      if (cell1 != null && cell1 == cell2 && cell2 == cell3) {
        return lastPlayer == PlayerSymbol.x ? GameStatus.xWins : GameStatus.oWins;
      }
    }

    // Check for draw
    bool hasEmpty = false;
    for (final row in board) {
      for (final cell in row) {
        if (cell == null) {
          hasEmpty = true;
          break;
        }
      }
    }

    if (!hasEmpty) {
      return GameStatus.draw;
    }

    return GameStatus.active;
  }

  GameState resetGame() {
    return GameState(
      board: List.generate(
        3,
        (_) => List<PlayerSymbol?>.filled(3, null),
      ),
      currentTurn: PlayerSymbol.x,
      status: GameStatus.active,
      xPlayer: xPlayer,
      oPlayer: oPlayer,
    );
  }

  GameState resetScores() {
    return GameState(
      board: List.generate(
        3,
        (_) => List<PlayerSymbol?>.filled(3, null),
      ),
      currentTurn: PlayerSymbol.x,
      status: GameStatus.active,
      xPlayer: xPlayer.copyWith(wins: 0),
      oPlayer: oPlayer.copyWith(wins: 0),
    );
  }
}
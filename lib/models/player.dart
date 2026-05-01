enum PlayerSymbol { x, o }

class Player {
  final PlayerSymbol symbol;
  final String name;
  final int wins;

  const Player({
    required this.symbol,
    required this.name,
    this.wins = 0,
  });

  Player copyWith({
    PlayerSymbol? symbol,
    String? name,
    int? wins,
  }) {
    return Player(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      wins: wins ?? this.wins,
    );
  }

  static const Player playerX = Player(
    symbol: PlayerSymbol.x,
    name: 'X',
    wins: 0,
  );

  static const Player playerO = Player(
    symbol: PlayerSymbol.o,
    name: 'O',
    wins: 0,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.symbol == symbol &&
        other.name == name &&
        other.wins == wins;
  }

  @override
  int get hashCode => symbol.hashCode ^ name.hashCode ^ wins.hashCode;
}
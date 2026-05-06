import 'package:new_project_app/models/transaction.dart'; 

class TransactionStore {
  static final TransactionStore _instance = TransactionStore._internal();
  factory TransactionStore() => _instance;
  TransactionStore._internal();

  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalBalance => totalIncome - totalExpense;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
  }
}
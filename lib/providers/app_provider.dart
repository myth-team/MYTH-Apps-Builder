import 'package:flutter/foundation.dart';
import 'package:shop_ledger_app/models/transaction_model.dart'; 
import 'package:shop_ledger_app/services/storage_service.dart'; 

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  List<TransactionModel> _transactions = [];
  List<ProductModel> _products = [];
  List<CustomerModel> _customers = [];
  List<LoanModel> _loans = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  List<TransactionModel> get transactions => _transactions;
  List<ProductModel> get products => _products;
  List<CustomerModel> get customers => _customers;
  List<LoanModel> get loans => _loans;
  List<LoanModel> get pendingLoans => _loans.where((l) => !l.isPaid).toList();
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  double get totalBalance => (_stats['totalIncome'] ?? 0.0) - (_stats['totalExpenses'] ?? 0.0);
  double get totalIncome => _stats['totalIncome'] ?? 0.0;
  double get totalExpenses => _stats['totalExpenses'] ?? 0.0;
  int get totalSales => _stats['totalSales'] ?? 0;
  int get totalProducts => _stats['totalProducts'] ?? 0;
  int get totalCustomers => _stats['totalCustomers'] ?? 0;
  int get totalReturns => _stats['totalReturns'] ?? 0;
  int get totalLoans => _stats['totalLoans'] ?? 0;
  int get pendingLoansCount => _stats['pendingLoans'] ?? 0;
  double get totalLoanAmount => _stats['totalLoanAmount'] ?? 0.0;
  double get pendingLoanAmount => _stats['pendingLoanAmount'] ?? 0.0;

  Future<void> initialize() async {
    await _storageService.initializeSampleData();
    await loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    _transactions = await _storageService.getTransactions();
    _products = await _storageService.getProducts();
    _customers = await _storageService.getCustomers();
    _loans = await _storageService.getLoans();
    _stats = await _storageService.getStats();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction({
    required String title,
    required String subtitle,
    required double amount,
    required bool isIncome,
    required String type,
  }) async {
    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: subtitle,
      amount: amount,
      isIncome: isIncome,
      type: type,
      createdAt: DateTime.now(),
    );
    await _storageService.addTransaction(transaction);
    await loadData();
  }

  Future<void> updateTransaction({
    required String id,
    required String title,
    required String subtitle,
    required double amount,
    required bool isIncome,
    required String type,
  }) async {
    await _storageService.updateTransaction(
      id: id,
      title: title,
      subtitle: subtitle,
      amount: amount,
      isIncome: isIncome,
      type: type,
    );
    await loadData();
  }

  Future<void> deleteTransaction(String id) async {
    await _storageService.deleteTransaction(id);
    await loadData();
  }

  Future<void> addProduct({
    required String name,
    required double price,
    required int stock,
  }) async {
    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      stock: stock,
      createdAt: DateTime.now(),
    );
    await _storageService.addProduct(product);
    await loadData();
  }

  Future<void> addCustomer({
    required String name,
    required double totalPurchases,
  }) async {
    final customer = CustomerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      totalPurchases: totalPurchases,
      createdAt: DateTime.now(),
    );
    await _storageService.addCustomer(customer);
    await loadData();
  }

  Future<void> addLoan({
    required String customerName,
    required double amount,
    String? description,
  }) async {
    final loan = LoanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      amount: amount,
      remainingAmount: amount,
      isPaid: false,
      description: description,
      createdAt: DateTime.now(),
    );
    await _storageService.addLoan(loan);
    await loadData();
  }

  Future<void> updateLoan({
    required String id,
    required String customerName,
    required double amount,
    required double remainingAmount,
    required bool isPaid,
    String? description,
    DateTime? paidAt,
  }) async {
    final loan = LoanModel(
      id: id,
      customerName: customerName,
      amount: amount,
      remainingAmount: remainingAmount,
      isPaid: isPaid,
      description: description,
      createdAt: _loans.firstWhere((l) => l.id == id).createdAt,
      paidAt: paidAt,
    );
    await _storageService.updateLoan(loan);
    await loadData();
  }

  Future<void> markLoanAsPaid(String id) async {
    final loan = _loans.firstWhere((l) => l.id == id);
    final updatedLoan = loan.copyWith(
      isPaid: true,
      remainingAmount: 0,
      paidAt: DateTime.now(),
    );
    await _storageService.updateLoan(updatedLoan);
    await loadData();
  }

  Future<void> makePartialPayment(String id, double paymentAmount) async {
    final loan = _loans.firstWhere((l) => l.id == id);
    final newRemaining = loan.remainingAmount - paymentAmount;
    final isFullyPaid = newRemaining <= 0;
    final updatedLoan = loan.copyWith(
      remainingAmount: isFullyPaid ? 0 : newRemaining,
      isPaid: isFullyPaid,
      paidAt: isFullyPaid ? DateTime.now() : null,
    );
    await _storageService.updateLoan(updatedLoan);
    await loadData();
  }

  Future<void> deleteLoan(String id) async {
    await _storageService.deleteLoan(id);
    await loadData();
  }
}
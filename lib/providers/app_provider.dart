import 'package:flutter/foundation.dart';
import 'package:shop_ledger_app/models/transaction_model.dart'; 
import 'package:shop_ledger_app/services/storage_service.dart'; 

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  List<TransactionModel> _transactions = [];
  List<ProductModel> _products = [];
  List<CustomerModel> _customers = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  List<TransactionModel> get transactions => _transactions;
  List<ProductModel> get products => _products;
  List<CustomerModel> get customers => _customers;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  double get totalBalance => (_stats['totalIncome'] ?? 0.0) - (_stats['totalExpenses'] ?? 0.0);
  double get totalIncome => _stats['totalIncome'] ?? 0.0;
  double get totalExpenses => _stats['totalExpenses'] ?? 0.0;
  int get totalSales => _stats['totalSales'] ?? 0;
  int get totalProducts => _stats['totalProducts'] ?? 0;
  int get totalCustomers => _stats['totalCustomers'] ?? 0;
  int get totalReturns => _stats['totalReturns'] ?? 0;

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
}
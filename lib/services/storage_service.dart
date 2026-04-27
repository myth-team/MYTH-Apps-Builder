import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_ledger_app/models/transaction_model.dart'; 

class StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _productsKey = 'products';
  static const String _customersKey = 'customers';
  static const String _loansKey = 'loans';
  static const String _statsKey = 'stats';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await _prefs;
    final String? data = prefs.getString(_transactionsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final prefs = await _prefs;
    final String data = json.encode(transactions.map((e) => e.toJson()).toList());
    await prefs.setString(_transactionsKey, data);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    transactions.insert(0, transaction);
    await saveTransactions(transactions);
    await _updateStats();
  }

  Future<void> updateTransaction({
    required String id,
    required String title,
    required String subtitle,
    required double amount,
    required bool isIncome,
    required String type,
  }) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      transactions[index] = TransactionModel(
        id: id,
        title: title,
        subtitle: subtitle,
        amount: amount,
        isIncome: isIncome,
        type: type,
        createdAt: transactions[index].createdAt,
      );
      await saveTransactions(transactions);
      await _updateStats();
    }
  }

  Future<void> deleteTransaction(String id) async {
    final transactions = await getTransactions();
    transactions.removeWhere((t) => t.id == id);
    await saveTransactions(transactions);
    await _updateStats();
  }

  Future<List<ProductModel>> getProducts() async {
    final prefs = await _prefs;
    final String? data = prefs.getString(_productsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> saveProducts(List<ProductModel> products) async {
    final prefs = await _prefs;
    final String data = json.encode(products.map((e) => e.toJson()).toList());
    await prefs.setString(_productsKey, data);
  }

  Future<void> addProduct(ProductModel product) async {
    final products = await getProducts();
    products.add(product);
    await saveProducts(products);
    await _updateStats();
  }

  Future<List<CustomerModel>> getCustomers() async {
    final prefs = await _prefs;
    final String? data = prefs.getString(_customersKey);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => CustomerModel.fromJson(e)).toList();
  }

  Future<void> saveCustomers(List<CustomerModel> customers) async {
    final prefs = await _prefs;
    final String data = json.encode(customers.map((e) => e.toJson()).toList());
    await prefs.setString(_customersKey, data);
  }

  Future<void> addCustomer(CustomerModel customer) async {
    final customers = await getCustomers();
    customers.add(customer);
    await saveCustomers(customers);
    await _updateStats();
  }

  Future<List<LoanModel>> getLoans() async {
    final prefs = await _prefs;
    final String? data = prefs.getString(_loansKey);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => LoanModel.fromJson(e)).toList();
  }

  Future<void> saveLoans(List<LoanModel> loans) async {
    final prefs = await _prefs;
    final String data = json.encode(loans.map((e) => e.toJson()).toList());
    await prefs.setString(_loansKey, data);
  }

  Future<void> addLoan(LoanModel loan) async {
    final loans = await getLoans();
    loans.insert(0, loan);
    await saveLoans(loans);
    await _updateStats();
  }

  Future<void> updateLoan(LoanModel loan) async {
    final loans = await getLoans();
    final index = loans.indexWhere((l) => l.id == loan.id);
    if (index != -1) {
      loans[index] = loan;
      await saveLoans(loans);
      await _updateStats();
    }
  }

  Future<void> deleteLoan(String id) async {
    final loans = await getLoans();
    loans.removeWhere((l) => l.id == id);
    await saveLoans(loans);
    await _updateStats();
  }

  Future<Map<String, dynamic>> getStats() async {
    final prefs = await _prefs;
    final String? data = prefs.getString(_statsKey);
    if (data == null) {
      return {
        'totalSales': 0,
        'totalProducts': 0,
        'totalCustomers': 0,
        'totalReturns': 0,
        'totalIncome': 0.0,
        'totalExpenses': 0.0,
        'totalLoans': 0,
        'pendingLoans': 0,
        'totalLoanAmount': 0.0,
        'pendingLoanAmount': 0.0,
      };
    }
    return json.decode(data);
  }

  Future<void> _updateStats() async {
    final transactions = await getTransactions();
    final products = await getProducts();
    final customers = await getCustomers();
    final loans = await getLoans();

    double totalIncome = 0;
    double totalExpenses = 0;
    int totalSales = 0;
    int totalReturns = 0;
    int pendingLoans = 0;
    double totalLoanAmount = 0;
    double pendingLoanAmount = 0;

    for (var t in transactions) {
      if (t.isIncome) {
        totalIncome += t.amount;
        if (t.type == 'sale') totalSales++;
        if (t.type == 'return') totalReturns++;
      } else {
        totalExpenses += t.amount;
      }
    }

    for (var loan in loans) {
      totalLoanAmount += loan.amount;
      if (!loan.isPaid) {
        pendingLoans++;
        pendingLoanAmount += loan.remainingAmount;
      }
    }

    final stats = {
      'totalSales': totalSales,
      'totalProducts': products.length,
      'totalCustomers': customers.length,
      'totalReturns': totalReturns,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'totalLoans': loans.length,
      'pendingLoans': pendingLoans,
      'totalLoanAmount': totalLoanAmount,
      'pendingLoanAmount': pendingLoanAmount,
    };

    final prefs = await _prefs;
    await prefs.setString(_statsKey, json.encode(stats));
  }

  Future<void> initializeSampleData() async {
    final prefs = await _prefs;
    final bool hasData = prefs.getBool('hasInitializedData') ?? false;
    
    if (!hasData) {
      await prefs.setBool('hasInitializedData', true);
    }
  }
}
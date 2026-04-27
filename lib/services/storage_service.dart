import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_ledger_app/models/transaction_model.dart'; 

class StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _productsKey = 'products';
  static const String _customersKey = 'customers';
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
      };
    }
    return json.decode(data);
  }

  Future<void> _updateStats() async {
    final transactions = await getTransactions();
    final products = await getProducts();
    final customers = await getCustomers();

    double totalIncome = 0;
    double totalExpenses = 0;
    int totalSales = 0;
    int totalReturns = 0;

    for (var t in transactions) {
      if (t.isIncome) {
        totalIncome += t.amount;
        if (t.type == 'sale') totalSales++;
        if (t.type == 'return') totalReturns++;
      } else {
        totalExpenses += t.amount;
      }
    }

    final stats = {
      'totalSales': totalSales,
      'totalProducts': products.length,
      'totalCustomers': customers.length,
      'totalReturns': totalReturns,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
    };

    final prefs = await _prefs;
    await prefs.setString(_statsKey, json.encode(stats));
  }

  Future<void> initializeSampleData() async {
    final prefs = await _prefs;
    final bool hasData = prefs.getBool('hasInitializedData') ?? false;
    
    if (!hasData) {
      final now = DateTime.now();
      
      List<TransactionModel> sampleTransactions = [
        TransactionModel(
          id: '1',
          title: 'Sale - Electronics',
          subtitle: 'Customer: John Smith',
          amount: 850.00,
          isIncome: true,
          type: 'sale',
          createdAt: now.subtract(Duration(hours: 2)),
        ),
        TransactionModel(
          id: '2',
          title: 'Stock Purchase',
          subtitle: 'Supplier: Tech Supplies Co',
          amount: 2200.00,
          isIncome: false,
          type: 'expense',
          createdAt: now.subtract(Duration(hours: 4)),
        ),
        TransactionModel(
          id: '3',
          title: 'Sale - Accessories',
          subtitle: 'Customer: Sarah Johnson',
          amount: 145.00,
          isIncome: true,
          type: 'sale',
          createdAt: now.subtract(Duration(hours: 6)),
        ),
        TransactionModel(
          id: '4',
          title: 'Discount Given',
          subtitle: 'Sale ID: #1245',
          amount: 50.00,
          isIncome: false,
          type: 'discount',
          createdAt: now.subtract(Duration(days: 1)),
        ),
        TransactionModel(
          id: '5',
          title: 'Sale - Clothing',
          subtitle: 'Customer: Mike Brown',
          amount: 320.00,
          isIncome: true,
          type: 'sale',
          createdAt: now.subtract(Duration(days: 1)),
        ),
      ];

      List<ProductModel> sampleProducts = [
        ProductModel(id: '1', name: 'Smartphone X', price: 699.99, stock: 45, createdAt: now),
        ProductModel(id: '2', name: 'Laptop Pro', price: 1299.99, stock: 23, createdAt: now),
        ProductModel(id: '3', name: 'Wireless Earbuds', price: 149.99, stock: 120, createdAt: now),
      ];

      List<CustomerModel> sampleCustomers = [
        CustomerModel(id: '1', name: 'John Smith', totalPurchases: 2450.00, createdAt: now),
        CustomerModel(id: '2', name: 'Sarah Johnson', totalPurchases: 890.00, createdAt: now),
        CustomerModel(id: '3', name: 'Mike Brown', totalPurchases: 1560.00, createdAt: now),
      ];

      await saveTransactions(sampleTransactions);
      await saveProducts(sampleProducts);
      await saveCustomers(sampleCustomers);
      await _updateStats();
      await prefs.setBool('hasInitializedData', true);
    }
  }
}
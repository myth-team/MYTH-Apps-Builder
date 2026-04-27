class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final String type;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'isIncome': isIncome,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      amount: json['amount'].toDouble(),
      isIncome: json['isIncome'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final double price;
  final int stock;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CustomerModel {
  final String id;
  final String name;
  final double totalPurchases;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.totalPurchases,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalPurchases': totalPurchases,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      totalPurchases: json['totalPurchases'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
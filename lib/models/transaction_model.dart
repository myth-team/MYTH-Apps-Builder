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

class LoanModel {
  final String id;
  final String customerName;
  final double amount;
  final double remainingAmount;
  final bool isPaid;
  final String? description;
  final DateTime createdAt;
  final DateTime? paidAt;

  LoanModel({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.remainingAmount,
    required this.isPaid,
    this.description,
    required this.createdAt,
    this.paidAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'amount': amount,
      'remainingAmount': remainingAmount,
      'isPaid': isPaid,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      customerName: json['customerName'],
      amount: json['amount'].toDouble(),
      remainingAmount: json['remainingAmount'].toDouble(),
      isPaid: json['isPaid'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  LoanModel copyWith({
    String? id,
    String? customerName,
    double? amount,
    double? remainingAmount,
    bool? isPaid,
    String? description,
    DateTime? createdAt,
    DateTime? paidAt,
  }) {
    return LoanModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      isPaid: isPaid ?? this.isPaid,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
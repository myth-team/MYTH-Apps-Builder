import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

enum TransactionType { income, expense }

enum TransactionCategory { food, transport, salary, utilities, entertainment, other }

class Transaction {
  final String id;
  final double amount;
  final TransactionCategory category;
  final DateTime date;
  final TransactionType type;
  final String title;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.title,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  String get categoryName {
    switch (category) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.salary:
        return 'Salary';
      case TransactionCategory.utilities:
        return 'Utilities';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.other:
        return 'Other';
    }
  }

  Color get categoryColor {
    switch (category) {
      case TransactionCategory.food:
        return AppColors.categoryFood;
      case TransactionCategory.transport:
        return AppColors.categoryTransport;
      case TransactionCategory.salary:
        return AppColors.categorySalary;
      case TransactionCategory.utilities:
        return AppColors.categoryUtilities;
      case TransactionCategory.entertainment:
        return AppColors.categoryEntertainment;
      case TransactionCategory.other:
        return AppColors.categoryOther;
    }
  }

  IconData get icon {
    switch (category) {
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.salary:
        return Icons.work;
      case TransactionCategory.utilities:
        return Icons.bolt;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.other:
        return Icons.more_horiz;
    }
  }
}
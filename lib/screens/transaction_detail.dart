import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project_app/utils/colors.dart'; 

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String? ?? 'unknown';
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    final transaction = {
      'id': id,
      'title': 'Grocery Shopping',
      'category': 'Food',
      'categoryIcon': Icons.restaurant,
      'categoryColor': AppColors.success,
      'amount': -85.50,
      'date': DateTime.now(),
      'note': 'Weekly groceries from Whole Foods Market',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _AmountHeader(
              amount: transaction['amount'] as double,
              currencyFormat: currencyFormat,
            ),
            const SizedBox(height: 24),
            _DetailCard(
              title: transaction['title'] as String,
              category: transaction['category'] as String,
              categoryIcon: transaction['categoryIcon'] as IconData,
              categoryColor: transaction['categoryColor'] as Color,
              date: transaction['date'] as DateTime,
              note: transaction['note'] as String?,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _AmountHeader extends StatelessWidget {
  final double amount;
  final NumberFormat currencyFormat;

  const _AmountHeader({required this.amount, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    final isNegative = amount < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNegative
              ? [AppColors.error, AppColors.error.withOpacity(0.8)]
              : [AppColors.success, AppColors.success.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            isNegative ? 'Expense' : 'Income',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            currencyFormat.format(amount.abs()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;
  final DateTime date;
  final String? note;

  const _DetailCard({
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
    required this.date,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            icon: Icons.label_outline,
            label: 'Title',
            value: title,
          ),
          const Divider(height: 24),
          _DetailRow(
            icon: categoryIcon,
            iconColor: categoryColor,
            label: 'Category',
            value: category,
          ),
          const Divider(height: 24),
          _DetailRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: DateFormat.yMMMMd().format(date),
          ),
          if (note != null && note!.isNotEmpty) ...[
            const Divider(height: 24),
            _DetailRow(
              icon: Icons.notes,
              label: 'Note',
              value: note!,
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
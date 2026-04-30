import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_3_banking_forked_app/utils/colors.dart'; 

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
      type: TransactionType.deposit,
      title: 'IBAN Deposit',
      amount: 2500.00,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Transaction(
      type: TransactionType.spending,
      title: 'Starbucks',
      amount: -12.50,
      timestamp: DateTime.now().subtract(Duration(hours: 6)),
    ),
    Transaction(
      type: TransactionType.yield,
      title: 'Aave Yield',
      amount: 8.42,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      type: TransactionType.investment,
      title: 'Bought AAPL',
      amount: -150.00,
      timestamp: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      type: TransactionType.spending,
      title: 'Amazon',
      amount: -89.99,
      timestamp: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      type: TransactionType.deposit,
      title: 'IBAN Deposit',
      amount: 1200.00,
      timestamp: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 100),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildTransactionItem(transactions[index]);
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getTransactionColor(transaction.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: _getTransactionColor(transaction.type),
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTimestamp(transaction.timestamp),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount >= 0 ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: transaction.amount >= 0 
                      ? AppColors.success 
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${transaction.amount >= 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)} USDC',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return AppColors.deposit;
      case TransactionType.spending:
        return AppColors.spending;
      case TransactionType.yield:
        return AppColors.yield;
      case TransactionType.investment:
        return AppColors.investment;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.spending:
        return Icons.arrow_upward;
      case TransactionType.yield:
        return Icons.trending_up;
      case TransactionType.investment:
        return Icons.show_chart;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class Transaction {
  final TransactionType type;
  final String title;
  final double amount;
  final DateTime timestamp;

  Transaction({
    required this.type,
    required this.title,
    required this.amount,
    required this.timestamp,
  });
}

enum TransactionType {
  deposit,
  spending,
  yield,
  investment,
}
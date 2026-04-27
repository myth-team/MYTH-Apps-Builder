import 'package:flutter/material.dart';
import 'package:shop_ledger_pro_app/utils/colors.dart'; 

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final String date;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isIncome ? AppColors.income : AppColors.expense).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isIncome ? AppColors.income : AppColors.expense,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? AppColors.income : AppColors.expense,
            ),
          ),
        ],
      ),
    );
  }
}
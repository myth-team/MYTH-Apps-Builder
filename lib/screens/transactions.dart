import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/category_chip.dart'; 
import 'package:new_project_app/widgets/transaction_tile.dart'; 

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String? _selectedFilter;

  final List<String> _filters = ['All', 'Food', 'Transport', 'Entertainment', 'Shopping', 'Income'];

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'title': 'Grocery Shopping',
      'category': 'Food',
      'categoryIcon': Icons.restaurant,
      'categoryColor': AppColors.success,
      'amount': -85.50,
      'date': DateTime.now(),
      'note': 'Weekly groceries',
    },
    {
      'id': '2',
      'title': 'Uber Ride',
      'category': 'Transport',
      'categoryIcon': Icons.directions_car,
      'categoryColor': AppColors.accent,
      'amount': -24.00,
      'date': DateTime.now(),
    },
    {
      'id': '3',
      'title': 'Salary Deposit',
      'category': 'Income',
      'categoryIcon': Icons.work,
      'categoryColor': AppColors.primary,
      'amount': 3500.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'note': 'Monthly salary',
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == null || _selectedFilter == 'All') return _transactions;
    return _transactions.where((t) => t['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _FilterBar(
            filters: _filters,
            selectedFilter: _selectedFilter ?? 'All',
            onFilterSelected: (f) => setState(() => _selectedFilter = f == 'All' ? null : f),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final t = _filteredTransactions[index];
                return TransactionTile(
                  title: t['title'],
                  category: t['category'],
                  categoryIcon: t['categoryIcon'],
                  categoryColor: t['categoryColor'],
                  amount: t['amount'],
                  date: t['date'],
                  note: t['note'],
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/transaction_detail',
                    arguments: t['id'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_transaction'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const _FilterBar({
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Center(
            child: CategoryFilterChip(
              label: filter,
              isSelected: filter == selectedFilter,
              onTap: () => onFilterSelected(filter),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/transaction_tile.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _recentTransactions = [
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
      'title': 'Salary Deposit',
      'category': 'Income',
      'categoryIcon': Icons.work,
      'categoryColor': AppColors.primary,
      'amount': 3500.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'note': 'Monthly salary',
    },
    {
      'id': '3',
      'title': 'Netflix Subscription',
      'category': 'Entertainment',
      'categoryIcon': Icons.movie,
      'categoryColor': AppColors.warning,
      'amount': -15.99,
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _DashboardView(
              transactions: _recentTransactions,
              onTransactionTap: (id) => Navigator.pushNamed(
                context,
                '/transaction_detail',
                arguments: id,
              ),
            ),
            const _TransactionsPlaceholder(),
            const _SettingsPlaceholder(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/transactions');
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/settings');
            return;
          }
          setState(() => _currentIndex = index);
        },
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.settings, color: AppColors.primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(String) onTransactionTap;

  const _DashboardView({
    required this.transactions,
    required this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final totalBalance = 12450.75;
    final monthlySpending = 2840.50;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormat.format(totalBalance),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                      icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SummaryCard(
                  title: 'This Month',
                  amount: monthlySpending,
                  subtitle: 'Spending',
                  color: AppColors.warning,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/transactions'),
                      child: const Text('See All', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final t = transactions[index];
              return TransactionTile(
                title: t['title'],
                category: t['category'],
                categoryIcon: t['categoryIcon'],
                categoryColor: t['categoryColor'],
                amount: t['amount'],
                date: t['date'],
                note: t['note'],
                onTap: () => onTransactionTap(t['id']),
              );
            },
            childCount: transactions.length,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String subtitle;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsPlaceholder extends StatelessWidget {
  const _TransactionsPlaceholder();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('Navigate via bottom nav', style: TextStyle(color: AppColors.textMuted)),
  );
}

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('Navigate via bottom nav', style: TextStyle(color: AppColors.textMuted)),
  );
}
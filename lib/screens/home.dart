import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_ledger_app/utils/colors.dart'; 
import 'package:pocket_ledger_app/screens/add_expense.dart'; 

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> expenses = [
    {
      'name': 'Groceries',
      'amount': 45.99,
      'date': 'Oct 1',
      'category': 'Food',
      'icon': Icons.restaurant,
      'color': Colors.orange
    },
    {
      'name': 'Coffee',
      'amount': 3.50,
      'date': 'Oct 2',
      'category': 'Food',
      'icon': Icons.coffee,
      'color': Colors.brown
    },
    {
      'name': 'Transport',
      'amount': 12.00,
      'date': 'Oct 3',
      'category': 'Transport',
      'icon': Icons.directions_bus,
      'color': Color(0xFF27AE60)
    },
  ];

  String _getCategoryName(String category) {
    final names = {
      'Food': 'Food & Dining',
      'Transport': 'Transportation',
      'Groceries': 'Groceries',
      'Entertainment': 'Entertainment',
      'Utilities': 'Utilities',
      'Other': 'Other'
    };
    return names[category] ?? category;
  }

  @override
  Widget build(BuildContext context) {
    double total = expenses.fold(0.0, (sum, expense) => sum + expense['amount']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket Ledger', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Spending',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        )),
                    SizedBox(height: 8),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildCategoryChip('Food', Colors.orange),
                        SizedBox(width: 8),
                        _buildCategoryChip('Transport', Color(0xFF27AE60)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: expense['color'] as Color,
                        ),
                        child: Icon(
                          expense['icon'],
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        expense['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getCategoryName(expense['category']),
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            expense['date'],
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${expense['amount'].toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          if (newExpense != null) {
            setState(() {
              expenses.add(newExpense);
            });
          }
        },
        icon: Icon(Icons.add),
        label: Text('New Expense', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildCategoryChip(String category, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getCategoryName(category),
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
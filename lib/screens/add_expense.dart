import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_ledger_app/utils/colors.dart'; 

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';
  final categories = [
    'Food',
    'Transport',
    'Groceries',
    'Entertainment',
    'Utilities',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Expense', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInputField(
              controller: _nameController,
              label: 'Expense Name',
              icon: Icons.description,
            ),
            SizedBox(height: 20),
            _buildInputField(
              controller: _amountController,
              label: 'Amount',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _buildCategorySelector(),
            SizedBox(height: 20),
            _buildDatePicker(),
            Spacer(),
            ElevatedButton(
              onPressed: _submitExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Add Expense',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButton<String>(
        value: _selectedCategory,
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: GoogleFonts.poppins(),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedCategory = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Date',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        subtitle: Text(
          '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.calendar_today, color: AppColors.primaryColor),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2015),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            setState(() {
              _selectedDate = pickedDate;
            });
          }
        },
      ),
    );
  }

  void _submitExpense() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid amount'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'name': _nameController.text,
      'amount': amount,
      'date': '${_selectedDate.month}/${_selectedDate.day}',
      'category': _selectedCategory,
      'icon': _getCategoryIcon(_selectedCategory),
      'color': _getCategoryColor(_selectedCategory),
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;
      case 'Groceries':
        return Icons.shopping_cart;
      case 'Entertainment':
        return Icons.movie;
      case 'Utilities':
        return Icons.electric_bolt;
      default:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Color(0xFF27AE60);
      case 'Groceries':
        return Colors.green;
      case 'Entertainment':
        return Colors.purple;
      case 'Utilities':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
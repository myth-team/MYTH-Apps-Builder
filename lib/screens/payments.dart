import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  bool _cashPreferred = false;
  bool _showAddCard = false;

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final _mockCards = [
    ('Visa', '4242', true),
    ('Mastercard', '8888', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Payment Methods', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletCard(),
            SizedBox(height: 16),
            _buildCashToggle(),
            SizedBox(height: 16),
            Text('Saved Cards', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            ..._mockCards.map((card) => _buildCardTile(card.$1, card.$2, card.$3)),
            SizedBox(height: 8),
            _buildAddCardSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Icon(Icons.account_balance_wallet, color: Colors.white70),
              ],
            ),
            SizedBox(height: 8),
            Text('\$47.50', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Top Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashToggle() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        value: _cashPreferred,
        onChanged: (v) => setState(() => _cashPreferred = v),
        title: Row(
          children: [
            Icon(Icons.money, color: AppColors.success),
            SizedBox(width: 12),
            Text('Cash Preferred', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        subtitle: Text('Pay driver directly with cash', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildCardTile(String brand, String last4, bool isDefault) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.credit_card, color: AppColors.primary),
        title: Text('$brand ending in $last4', style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: isDefault ? Text('Default', style: TextStyle(fontSize: 12, color: AppColors.success)) : null,
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildAddCardSection() {
    if (!_showAddCard) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => setState(() => _showAddCard = true),
          icon: Icon(Icons.add),
          label: Text('Add New Card'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Card', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => _showAddCard = false),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showAddCard = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}
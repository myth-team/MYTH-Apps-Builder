import 'package:flutter/material.dart';
import 'package:ruby_rose_jewels_app/utils/colors.dart'; 

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('Shipping Address'),
              const SizedBox(height: 12),
              _buildTextField(_nameController, 'Full Name', Icons.person_outline),
              const SizedBox(height: 12),
              _buildTextField(_addressController, 'Street Address', Icons.home_outlined),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField(_cityController, 'City', Icons.location_city)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(_zipController, 'ZIP Code', Icons.pin_drop, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 24),
              _SectionTitle('Order Summary'),
              const SizedBox(height: 12),
              _OrderSummary(),
              const SizedBox(height: 24),
              _PlaceOrderButton(formKey: _formKey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary));
  }
}

class _OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Rose Gold Diamond Ring', 'qty': 1, 'price': 299.99},
      {'name': 'Pearl Necklace', 'qty': 2, 'price': 149.99},
    ];
    final subtotal = items.fold(0.0, (sum, item) => sum + (item['price'] as double) * (item['qty'] as int));
    final shipping = 9.99;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        children: [
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${item['name']} x${item['qty']}', style: TextStyle(color: AppColors.textSecondary)),
                Text('\$${(item['price'] as double).toStringAsFixed(2)}', style: TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          )),
          Divider(color: AppColors.divider),
          _summaryRow('Subtotal', subtotal),
          _summaryRow('Shipping', shipping),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ]),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary)),
        Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(color: AppColors.textPrimary)),
      ]),
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _PlaceOrderButton({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _showOrderConfirmation(context);
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text('Thank you for your purchase. Your order has been placed successfully.'),
        actions: [
          TextButton(onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).popUntil((route) => route.isFirst); }, child: const Text('OK')),
        ],
      ),
    );
  }
}
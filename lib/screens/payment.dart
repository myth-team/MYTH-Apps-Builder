import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/payment_method.dart'; 
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 
import 'package:ridenow_go_app/widgets/price_tag.dart'; 

class PaymentScreen extends StatefulWidget {
  final Ride? ride;

  PaymentScreen({this.ride});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Ride? _ride;
  PaymentMethod? _selectedPaymentMethod;
  double? _selectedTip;
  bool _isProcessing = false;

  final List<double> _tipOptions = [0, 2, 3, 5];

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'pm_1',
      type: PaymentType.creditCard,
      displayName: 'Visa',
      lastFourDigits: '4242',
      cardBrand: CardBrand.visa,
      isDefault: true,
    ),
    PaymentMethod(
      id: 'pm_2',
      type: PaymentType.digitalWallet,
      displayName: 'Apple Pay',
      isDefault: false,
    ),
    PaymentMethod(
      id: 'pm_3',
      type: PaymentType.cash,
      displayName: 'Cash',
      isDefault: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ride = widget.ride;
    _selectedPaymentMethod = _paymentMethods.firstWhere(
      (pm) => pm.isDefault,
      orElse: () => _paymentMethods.first,
    );
    _selectedTip = _tipOptions.first;
  }

  double get _subtotal {
    return _ride?.finalFare ?? _ride?.estimatedFare ?? 0;
  }

  double get _tipAmount {
    return _selectedTip ?? 0;
  }

  double get _totalAmount {
    return _subtotal + _tipAmount;
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      _showPaymentSuccess();
    }
  }

  void _showPaymentSuccess() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.buildGradient(AppColors.successGradient),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Thank you for riding with us',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24),
            _buildSuccessDetailRow('Amount Paid', '\$${_totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            _buildSuccessDetailRow('Payment Method', _selectedPaymentMethod?.displayName ?? '--'),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.download_rounded,
                    label: 'Receipt',
                    onTap: () {
                      // Download receipt
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.buildGradient(AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home',
                            (route) => false,
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRideSummary(),
            SizedBox(height: 20),
            FareBreakdown(
              baseFare: _subtotal * 0.3,
              distanceFare: _subtotal * 0.4,
              timeFare: _subtotal * 0.3,
              subtotal: _subtotal,
              tipAmount: _tipAmount,
              total: _totalAmount,
            ),
            SizedBox(height: 20),
            _buildPaymentMethods(),
            SizedBox(height: 20),
            _buildTipSection(),
            SizedBox(height: 20),
            _buildPromoSection(),
            SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(),
    );
  }

  Widget _buildRideSummary() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.buildGradient(AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ride Summary',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _ride?.typeDisplay ?? 'Ride',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _ride?.status == RideStatus.completed ? 'Completed' : 'Pending',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSummaryRow(
            icon: Icons.route_rounded,
            label: 'Distance',
            value: _ride?.distanceDisplay ?? '--',
          ),
          SizedBox(height: 12),
          _buildSummaryRow(
            icon: Icons.timer_rounded,
            label: 'Duration',
            value: _ride?.durationDisplay ?? '--',
          ),
          SizedBox(height: 12),
          _buildSummaryRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: _ride?.completedAt != null
                ? '${_ride!.completedAt!.day}/${_ride!.completedAt!.month}/${_ride!.completedAt!.year}'
                : '--',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.white.withOpacity(0.7),
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        ..._paymentMethods.map((pm) => _buildPaymentMethodItem(pm)),
      ],
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethod method) {
    final isSelected = _selectedPaymentMethod?.id == method.id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getPaymentMethodColor(method).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getPaymentMethodIcon(method),
                color: _getPaymentMethodColor(method),
                size: 24,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.displayName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (method.maskedNumber != null) ...[
                    SizedBox(height: 2),
                    Text(
                      method.maskedNumber!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.buildGradient(AppColors.primaryGradient),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method.type) {
      case PaymentType.creditCard:
      case PaymentType.debitCard:
        return Icons.credit_card_rounded;
      case PaymentType.digitalWallet:
        return Icons.account_balance_wallet_rounded;
      case PaymentType.cash:
        return Icons.payments_rounded;
    }
  }

  Color _getPaymentMethodColor(PaymentMethod method) {
    switch (method.type) {
      case PaymentType.creditCard:
      case PaymentType.debitCard:
        return AppColors.cardVisa;
      case PaymentType.digitalWallet:
        return AppColors.primary;
      case PaymentType.cash:
        return AppColors.cash;
    }
  }

  Widget _buildTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tip Driver',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: _tipOptions.map((tip) {
            final isSelected = _selectedTip == tip;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTip = tip;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? AppColors.buildGradient(AppColors.accentGradient)
                          : null,
                      color: isSelected ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.secondary : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tip == 0 ? 'No Tip' : '\$${tip.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer_rounded,
            color: AppColors.success,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promo Code',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _ride?.promoCode != null
                      ? 'Applied: ${_ride!.promoCode}'
                      : 'Add a promo code',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${_totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.buildGradient(AppColors.primaryGradient),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isProcessing ? null : _processPayment,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: _isProcessing
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Pay Now',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
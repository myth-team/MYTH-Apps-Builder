import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/auth_provider.dart';
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/widgets/ride_state_chip.dart'; 

class RiderPaymentScreen extends StatefulWidget {
  const RiderPaymentScreen({Key? key}) : super(key: key);

  @override
  State<RiderPaymentScreen> createState() => _RiderPaymentScreenState();
}

class _RiderPaymentScreenState extends State<RiderPaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TripRecord? _receiptTrip;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showReceipt(TripRecord trip) {
    setState(() => _receiptTrip = trip);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DigitalReceiptModal(trip: trip),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final rideProvider = context.watch<RideProvider>();
    final double walletBalance = authProvider.walletBalance;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildWalletCard(walletBalance, authProvider),
          _buildPaymentMethodSelector(rideProvider),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionHistory(rideProvider),
                _buildTopUpSection(authProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.grey800),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Payment',
        style: GoogleFonts.poppins(
          color: AppColors.grey900,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline_rounded, color: AppColors.grey600),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWalletCard(double balance, AuthProvider authProvider) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.walletGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.35),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MYTH Wallet',
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet_rounded,
                          color: AppColors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Active',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Available Balance',
              style: GoogleFonts.poppins(
                color: AppColors.white.withOpacity(0.75),
                fontSize: 13,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _buildWalletAction(
                  icon: Icons.add_rounded,
                  label: 'Top Up',
                  onTap: () => _tabController.animateTo(1),
                ),
                SizedBox(width: 12),
                _buildWalletAction(
                  icon: Icons.send_rounded,
                  label: 'Transfer',
                  onTap: () {},
                ),
                SizedBox(width: 12),
                _buildWalletAction(
                  icon: Icons.history_rounded,
                  label: 'History',
                  onTap: () => _tabController.animateTo(0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 16),
            SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector(RideProvider rideProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowNeutral,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Default Payment Method',
            style: GoogleFonts.poppins(
              color: AppColors.grey600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildPaymentMethodOption(
                method: PaymentMethod.wallet,
                icon: Icons.account_balance_wallet_rounded,
                label: 'Wallet',
                subtitle: 'Fast & secure',
                selected: rideProvider.selectedPaymentMethod == PaymentMethod.wallet,
                onTap: () => rideProvider.setPaymentMethod(PaymentMethod.wallet),
              ),
              SizedBox(width: 12),
              _buildPaymentMethodOption(
                method: PaymentMethod.card,
                icon: Icons.credit_card_rounded,
                label: 'Card',
                subtitle: '•••• 4242',
                selected: rideProvider.selectedPaymentMethod == PaymentMethod.card,
                onTap: () => rideProvider.setPaymentMethod(PaymentMethod.card),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required PaymentMethod method,
    required IconData icon,
    required String label,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primarySurface : AppColors.grey100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: selected ? AppColors.primary : AppColors.grey500,
                    size: 22,
                  ),
                  if (selected)
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(Icons.check_rounded,
                          color: AppColors.white, size: 12),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: selected ? AppColors.primary : AppColors.grey800,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: selected
                      ? AppColors.primaryLight
                      : AppColors.grey500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowNeutral,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        indicatorPadding: EdgeInsets.all(4),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey500,
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: 'Transactions'),
          Tab(text: 'Top Up'),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(RideProvider rideProvider) {
    final trips = rideProvider.tripHistory;

    if (trips.isEmpty) {
      return _buildEmptyHistory();
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return _TransactionTile(
          trip: trips[index],
          onTap: () => _showReceipt(trips[index]),
        );
      },
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: 38,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: GoogleFonts.poppins(
              color: AppColors.grey800,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your trip history will appear here',
            style: GoogleFonts.poppins(
              color: AppColors.grey500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpSection(AuthProvider authProvider) {
    final List<double> amounts = [10, 25, 50, 100, 200, 500];
    double? _selectedAmount;

    return StatefulBuilder(
      builder: (context, setS) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Amount',
                style: GoogleFonts.poppins(
                  color: AppColors.grey800,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                ),
                itemCount: amounts.length,
                itemBuilder: (_, i) {
                  final amt = amounts[i];
                  final isSelected = _selectedAmount == amt;
                  return GestureDetector(
                    onTap: () => setS(() => _selectedAmount = amt),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primarySurface
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.borderLight,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '\$${amt.toInt()}',
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey800,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildCustomAmountField(setS, (val) => _selectedAmount = val),
              SizedBox(height: 24),
              Text(
                'Payment Via',
                style: GoogleFonts.poppins(
                  color: AppColors.grey800,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              _buildPaymentProviderList(),
              SizedBox(height: 24),
              GestureDetector(
                onTap: _selectedAmount != null
                    ? () {
                        authProvider.topUpWallet(_selectedAmount!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Wallet topped up with \$${_selectedAmount!.toInt()}!',
                              style: GoogleFonts.poppins(
                                  color: AppColors.white),
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        setS(() => _selectedAmount = null);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _selectedAmount != null
                        ? AppColors.primaryGradient
                        : null,
                    color: _selectedAmount == null ? AppColors.grey200 : null,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: _selectedAmount != null
                        ? [
                            BoxShadow(
                              color: AppColors.shadowPrimary,
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _selectedAmount != null
                          ? 'Top Up \$${_selectedAmount!.toInt()}'
                          : 'Select an Amount',
                      style: GoogleFonts.poppins(
                        color: _selectedAmount != null
                            ? AppColors.white
                            : AppColors.grey500,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomAmountField(
      StateSetter setS, Function(double) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.poppins(
          color: AppColors.grey900,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter custom amount',
          hintStyle: GoogleFonts.poppins(
            color: AppColors.grey400,
            fontSize: 14,
          ),
          prefixText: '\$ ',
          prefixStyle: GoogleFonts.poppins(
            color: AppColors.grey600,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        onChanged: (val) {
          final parsed = double.tryParse(val);
          if (parsed != null && parsed > 0) {
            setS(() => onChanged(parsed));
          }
        },
      ),
    );
  }

  Widget _buildPaymentProviderList() {
    final providers = [
      {'name': 'Visa / Mastercard', 'icon': Icons.credit_card_rounded},
      {'name': 'Apple Pay', 'icon': Icons.apple_rounded},
      {'name': 'Google Pay', 'icon': Icons.g_mobiledata_rounded},
    ];

    return Column(
      children: providers
          .map(
            (p) => Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Icon(p['icon'] as IconData,
                      color: AppColors.grey600, size: 22),
                  SizedBox(width: 12),
                  Text(
                    p['name'] as String,
                    style: GoogleFonts.poppins(
                      color: AppColors.grey800,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: AppColors.grey400, size: 14),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TripRecord trip;
  final VoidCallback onTap;

  const _TransactionTile({
    Key? key,
    required this.trip,
    required this.onTap,
  }) : super(key: key);

  Color get _stateColor {
    switch (trip.finalState) {
      case RideState.completed:
        return AppColors.error;
      case RideState.cancelled:
        return AppColors.grey500;
      default:
        return AppColors.error;
    }
  }

  IconData get _stateIcon {
    switch (trip.finalState) {
      case RideState.completed:
        return Icons.directions_car_rounded;
      case RideState.cancelled:
        return Icons.cancel_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy • h:mm a').format(trip.dateTime);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowNeutral,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: trip.finalState == RideState.completed
                    ? AppColors.errorSurface
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_stateIcon, color: _stateColor, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.dropoffAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.grey900,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    dateStr,
                    style: GoogleFonts.poppins(
                      color: AppColors.grey500,
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      _statusBadge(trip.finalState),
                      SizedBox(width: 8),
                      _paymentBadge(trip.paymentMethod),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trip.finalState == RideState.cancelled
                      ? 'Cancelled'
                      : '-\$${trip.fare.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: trip.finalState == RideState.cancelled
                        ? AppColors.grey400
                        : AppColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Icon(Icons.receipt_long_rounded,
                    color: AppColors.grey300, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(RideState state) {
    final String label = state == RideState.completed ? 'Completed' : 'Cancelled';
    final Color color = state == RideState.completed ? AppColors.success : AppColors.grey500;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _paymentBadge(PaymentMethod method) {
    final String label = method == PaymentMethod.wallet ? 'Wallet' : 'Card';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DigitalReceiptModal extends StatelessWidget {
  final TripRecord trip;

  const _DigitalReceiptModal({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMMM d, yyyy').format(trip.dateTime);
    final timeStr = DateFormat('h:mm a').format(trip.dateTime);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Receipt header
          Container(
            margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.receipt_rounded,
                      color: AppColors.white, size: 28),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Digital Receipt',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '#${trip.tripId.substring(0, 12).toUpperCase()}',
                        style: GoogleFonts.poppins(
                          color: AppColors.white.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${trip.fare.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildReceiptRow('Date', dateStr),
                _buildReceiptRow('Time', timeStr),
                _buildDivider(),
                _buildReceiptRow('Pickup', trip.pickupAddress),
                _buildReceiptRow('Dropoff', trip.dropoffAddress),
                _buildDivider(),
                if (trip.driver != null)
                  _buildReceiptRow('Driver', trip.driver!.name),
                _buildReceiptRow(
                    'Vehicle', trip.vehicleType.name.toUpperCase()),
                _buildReceiptRow(
                    'Payment',
                    trip.paymentMethod == PaymentMethod.wallet
                        ? 'MYTH Wallet'
                        : 'Credit Card'),
                _buildDivider(),
                _buildReceiptRow('Base Fare',
                    '\$${(trip.fare * 0.6).toStringAsFixed(2)}'),
                _buildReceiptRow('Distance',
                    '\$${(trip.fare * 0.3).toStringAsFixed(2)}'),
                _buildReceiptRow(
                    'Service Fee', '\$${(trip.fare * 0.1).toStringAsFixed(2)}'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.poppins(
                        color: AppColors.grey900,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$${trip.fare.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download_rounded, size: 18),
                    label: Text('Download'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.share_rounded, size: 18),
                    label: Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.grey500,
              fontSize: 13,
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: AppColors.grey800,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: AppColors.borderLight,
        height: 1,
        thickness: 1,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:rideflow_app/utils/colors.dart'; 
import 'package:rideflow_app/widgets/primary_button.dart'; 
import 'package:intl/intl.dart';

/// Payment screen with wallet balance, payment methods, and ride history
/// Part of rider flow - allows managing payments and viewing transaction history
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWalletCard(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRideHistory(),
                  _buildPaymentMethods(),
                  _buildTransactions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your payments',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppRadius.medium,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'Rider',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$127.50',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.add,
                  label: 'Add Money',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Withdraw',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWalletAction(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    _tabController.animateTo(0);
                  },
                ),
              ),
            ],
          ),
        ],
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withOpacity(0.15),
          borderRadius: AppRadius.medium,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.textOnPrimary,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.screenPadding),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.medium,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.small,
          boxShadow: AppShadows.small,
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Rides'),
          Tab(text: 'Payment'),
          Tab(text: 'Transactions'),
        ],
      ),
    );
  }

  Widget _buildRideHistory() {
    final rides = _getSampleRides();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return _buildRideHistoryCard(ride);
      },
    );
  }

  Widget _buildRideHistoryCard(RideHistory ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppRadius.small,
                    ),
                    child: Icon(
                      _getRideTypeIcon(ride.rideType),
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.rideType,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ride.date,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '\$${ride.amount.toStringAsFixed(2)}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppRadius.small,
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.mapMarkerPickup,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppColors.border,
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.mapMarkerDropoff,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.pickupAddress,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ride.dropoffAddress,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusChip(ride.status),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View Receipt',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status) {
      case 'Completed':
        backgroundColor = AppColors.successLight;
        textColor = AppColors.success;
        break;
      case 'Cancelled':
        backgroundColor = AppColors.errorLight;
        textColor = AppColors.error;
        break;
      default:
        backgroundColor = AppColors.warningLight;
        textColor = AppColors.warning;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.full,
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final methods = _getSamplePaymentMethods();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: methods.length + 1,
      itemBuilder: (context, index) {
        if (index == methods.length) {
          return _buildAddPaymentMethodCard();
        }
        return _buildPaymentMethodCard(methods[index]);
      },
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: method.isDefault 
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppRadius.small,
            ),
            child: Center(
              child: Text(
                method.cardType,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method.cardName,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (method.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          'Default',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '•••• •••• •••• ${method.lastFour}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
            ),
            onSelected: (value) {
              if (value == 'default') {
                // Set as default
              } else if (value == 'delete') {
                // Delete method
              }
            },
            itemBuilder: (context) => [
              if (!method.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as Default'),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Remove'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentMethodCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.medium,
          border: Border.all(
            color: AppColors.primary,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Add Payment Method',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactions() {
    final transactions = _getSampleTransactions();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.type == TransactionType.credit
                  ? AppColors.successLight
                  : AppColors.errorLight,
              borderRadius: AppRadius.small,
            ),
            child: Icon(
              transaction.type == TransactionType.credit
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: transaction.type == TransactionType.credit
                  ? AppColors.success
                  : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.date,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == TransactionType.credit ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
            style: AppTextStyles.titleSmall.copyWith(
              color: transaction.type == TransactionType.credit
                  ? AppColors.success
                  : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRideTypeIcon(String rideType) {
    switch (rideType) {
      case 'Economy':
        return Icons.directions_car;
      case 'Comfort':
        return Icons.airport_shuttle;
      case 'Luxury':
        return Icons.directions_car;
      case 'XL':
        return Icons.people;
      default:
        return Icons.directions_car;
    }
  }

  List<RideHistory> _getSampleRides() {
    return [
      RideHistory(
        id: '1',
        rideType: 'Economy',
        pickupAddress: '123 Main Street, San Francisco',
        dropoffAddress: '456 Market Street, San Francisco',
        amount: 15.99,
        date: 'Mar 15, 2024 • 2:30 PM',
        status: 'Completed',
      ),
      RideHistory(
        id: '2',
        rideType: 'Comfort',
        pickupAddress: '789 Mission Street, San Francisco',
        dropoffAddress: '321 Howard Street, San Francisco',
        amount: 24.50,
        date: 'Mar 14, 2024 • 9:15 AM',
        status: 'Completed',
      ),
      RideHistory(
        id: '3',
        rideType: 'Economy',
        pickupAddress: '555 California Street, San Francisco',
        dropoffAddress: '100 Embarcadero, San Francisco',
        amount: 18.75,
        date: 'Mar 12, 2024 • 6:45 PM',
        status: 'Completed',
      ),
      RideHistory(
        id: '4',
        rideType: 'XL',
        pickupAddress: '1 Infinity Loop, Cupertino',
        dropoffAddress: '1600 Amphitheatre, Mountain View',
        amount: 85.00,
        date: 'Mar 10, 2024 • 10:00 AM',
        status: 'Cancelled',
      ),
      RideHistory(
        id: '5',
        rideType: 'Luxury',
        pickupAddress: '350 Fifth Avenue, New York',
        dropoffAddress: '30 Rockefeller Plaza, New York',
        amount: 45.00,
        date: 'Mar 8, 2024 • 3:20 PM',
        status: 'Completed',
      ),
    ];
  }

  List<PaymentMethod> _getSamplePaymentMethods() {
    return [
      PaymentMethod(
        id: '1',
        cardName: 'Visa •••• 4242',
        cardType: 'VISA',
        lastFour: '4242',
        isDefault: true,
      ),
      PaymentMethod(
        id: '2',
        cardName: 'Mastercard •••• 8888',
        cardType: 'MC',
        lastFour: '8888',
        isDefault: false,
      ),
      PaymentMethod(
        id: '3',
        cardName: 'Amex •••• 1234',
        cardType: 'AMEX',
        lastFour: '1234',
        isDefault: false,
      ),
    ];
  }

  List<Transaction> _getSampleTransactions() {
    return [
      Transaction(
        id: '1',
        description: 'Ride Payment - Economy',
        amount: 15.99,
        date: 'Mar 15, 2024',
        type: TransactionType.debit,
      ),
      Transaction(
        id: '2',
        description: 'Wallet Top-up',
        amount: 50.00,
        date: 'Mar 14, 2024',
        type: TransactionType.credit,
      ),
      Transaction(
        id: '3',
        description: 'Ride Payment - Comfort',
        amount: 24.50,
        date: 'Mar 14, 2024',
        type: TransactionType.debit,
      ),
      Transaction(
        id: '4',
        description: 'Refund - Cancelled Ride',
        amount: 18.75,
        date: 'Mar 13, 2024',
        type: TransactionType.credit,
      ),
      Transaction(
        id: '5',
        description: 'Wallet Top-up',
        amount: 100.00,
        date: 'Mar 10, 2024',
        type: TransactionType.credit,
      ),
    ];
  }
}

/// Model for ride history
class RideHistory {
  final String id;
  final String rideType;
  final String pickupAddress;
  final String dropoffAddress;
  final double amount;
  final String date;
  final String status;

  RideHistory({
    required this.id,
    required this.rideType,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.amount,
    required this.date,
    required this.status,
  });
}

/// Model for payment methods
class PaymentMethod {
  final String id;
  final String cardName;
  final String cardType;
  final String lastFour;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardName,
    required this.cardType,
    required this.lastFour,
    required this.isDefault,
  });
}

/// Enum for transaction types
enum TransactionType {
  credit,
  debit,
}

/// Model for transactions
class Transaction {
  final String id;
  final String description;
  final double amount;
  final String date;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}
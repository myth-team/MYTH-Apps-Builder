import 'package:flutter/material.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:intl/intl.dart';

class RiderHistory extends StatefulWidget {
  const RiderHistory({super.key});

  @override
  State<RiderHistory> createState() => _RiderHistoryState();
}

class _RiderHistoryState extends State<RiderHistory> {
  final List<TripHistoryItem> _trips = _generateMockTrips();

  static List<TripHistoryItem> _generateMockTrips() {
    return [
      TripHistoryItem(
        id: '1',
        pickupLocation: '123 Main Street, San Francisco',
        dropoffLocation: '456 Market Street, San Francisco',
        date: DateTime.now().subtract(const Duration(days: 1)),
        price: 15.50,
        status: TripStatus.completed,
        driverName: 'John D.',
        driverRating: 4.9,
        vehicleType: 'Economy',
        distance: 3.2,
        duration: const Duration(minutes: 12),
      ),
      TripHistoryItem(
        id: '2',
        pickupLocation: '789 Oak Avenue, San Francisco',
        dropoffLocation: '101 Pine Street, San Francisco',
        date: DateTime.now().subtract(const Duration(days: 2)),
        price: 22.75,
        status: TripStatus.completed,
        driverName: 'Sarah M.',
        driverRating: 5.0,
        vehicleType: 'Comfort',
        distance: 5.1,
        duration: const Duration(minutes: 18),
      ),
      TripHistoryItem(
        id: '3',
        pickupLocation: '202 Broadway, San Francisco',
        dropoffLocation: '303 Mission Street, San Francisco',
        date: DateTime.now().subtract(const Duration(days: 3)),
        price: 8.25,
        status: TripStatus.cancelled,
        driverName: 'Mike T.',
        driverRating: 4.7,
        vehicleType: 'Economy',
        distance: 1.5,
        duration: const Duration(minutes: 8),
      ),
      TripHistoryItem(
        id: '4',
        pickupLocation: '404 Howard Street, San Francisco',
        dropoffLocation: '505 Folsom Street, San Francisco',
        date: DateTime.now().subtract(const Duration(days: 5)),
        price: 11.00,
        status: TripStatus.completed,
        driverName: 'Emily R.',
        driverRating: 4.8,
        vehicleType: 'Economy',
        distance: 2.3,
        duration: const Duration(minutes: 10),
      ),
      TripHistoryItem(
        id: '5',
        pickupLocation: '606 Valencia Street, San Francisco',
        dropoffLocation: '707 Castro Street, San Francisco',
        date: DateTime.now().subtract(const Duration(days: 7)),
        price: 18.50,
        status: TripStatus.completed,
        driverName: 'David K.',
        driverRating: 4.9,
        vehicleType: 'Luxury',
        distance: 4.0,
        duration: const Duration(minutes: 15),
      ),
      TripHistoryItem(
        id: '6',
        pickupLocation: '808 Dolores Street, San Francisco',
        dropoffLocation: '909 Guerrero Street, San Francisco',
        date: DateTime.now().subtract(const Duration(days: 10)),
        price: 9.75,
        status: TripStatus.completed,
        driverName: 'Lisa P.',
        driverRating: 4.6,
        vehicleType: 'Economy',
        distance: 1.8,
        duration: const Duration(minutes: 7),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Trip History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: _trips.isEmpty ? _buildEmptyState() : _buildTripList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'No trips yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed trips will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList() {
    final groupedTrips = _groupTripsByDate(_trips);
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupedTrips.length,
      itemBuilder: (context, index) {
        final group = groupedTrips[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                group.dateLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ...group.trips.map((trip) => TripHistoryCard(
              trip: trip,
              onTap: () => _showReceiptModal(trip),
            )),
          ],
        );
      },
    );
  }

  List<TripDateGroup> _groupTripsByDate(List<TripHistoryItem> trips) {
    final Map<String, List<TripHistoryItem>> grouped = {};
    final now = DateTime.now();
    
    for (var trip in trips) {
      final difference = now.difference(trip.date).inDays;
      String label;
      
      if (difference == 0) {
        label = 'Today';
      } else if (difference == 1) {
        label = 'Yesterday';
      } else if (difference < 7) {
        label = 'Last ${DateFormat('EEEE').format(trip.date)}';
      } else {
        label = DateFormat('MMMM d, yyyy').format(trip.date);
      }
      
      grouped.putIfAbsent(label, () => []).add(trip);
    }
    
    return grouped.entries
        .map((e) => TripDateGroup(dateLabel: e.key, trips: e.value))
        .toList();
  }

  void _showReceiptModal(TripHistoryItem trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReceiptModal(trip: trip),
    );
  }
}

class TripDateGroup {
  final String dateLabel;
  final List<TripHistoryItem> trips;
  
  TripDateGroup({required this.dateLabel, required this.trips});
}

class TripHistoryItem {
  final String id;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime date;
  final double price;
  final TripStatus status;
  final String driverName;
  final double driverRating;
  final String vehicleType;
  final double distance;
  final Duration duration;

  TripHistoryItem({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.date,
    required this.price,
    required this.status,
    required this.driverName,
    required this.driverRating,
    required this.vehicleType,
    required this.distance,
    required this.duration,
  });
}

enum TripStatus { completed, cancelled, inProgress }

class TripHistoryCard extends StatelessWidget {
  final TripHistoryItem trip;
  final VoidCallback? onTap;

  const TripHistoryCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStatusIcon(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    trip.pickupLocation,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    trip.dropoffLocation,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${trip.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: trip.status == TripStatus.cancelled
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildStatusChip(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trip.vehicleType,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.straighten,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.distance.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.duration.inMinutes} min',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              trip.driverName.substring(0, 1),
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trip.driverName,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.starFilled,
                          ),
                          Text(
                            trip.driverRating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'View Receipt',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;
    
    switch (trip.status) {
      case TripStatus.completed:
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case TripStatus.cancelled:
        icon = Icons.cancel;
        color = AppColors.error;
        break;
      case TripStatus.inProgress:
        icon = Icons.directions_car;
        color = AppColors.info;
        break;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(26),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildStatusChip() {
    String label;
    Color backgroundColor;
    Color textColor;
    
    switch (trip.status) {
      case TripStatus.completed:
        label = 'Completed';
        backgroundColor = AppColors.success.withAlpha(26);
        textColor = AppColors.success;
        break;
      case TripStatus.cancelled:
        label = 'Cancelled';
        backgroundColor = AppColors.error.withAlpha(26);
        textColor = AppColors.error;
        break;
      case TripStatus.inProgress:
        label = 'In Progress';
        backgroundColor = AppColors.info.withAlpha(26);
        textColor = AppColors.info;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class ReceiptModal extends StatefulWidget {
  final TripHistoryItem trip;

  const ReceiptModal({super.key, required this.trip});

  @override
  State<ReceiptModal> createState() => _ReceiptModalState();
}

class _ReceiptModalState extends State<ReceiptModal> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip Receipt',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        widget.trip.driverName.substring(0, 1),
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.trip.driverName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: AppColors.starFilled),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.trip.driverRating}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.trip.vehicleType,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildRouteDetails(),
                const SizedBox(height: 20),
                _buildFareDetails(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
                  _buildPaymentDetails(),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                        label: Text('Chat', style: TextStyle(color: AppColors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.refresh, color: AppColors.textOnPrimary),
                        label: Text('Book Again', style: TextStyle(color: AppColors.textOnPrimary)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildRouteDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      widget.trip.pickupLocation,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 5),
            width: 2,
            height: 24,
            color: AppColors.grey300,
          ),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dropoff',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      widget.trip.dropoffLocation,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trip Distance',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${widget.trip.distance.toStringAsFixed(1)} km',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trip Duration',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${widget.trip.duration.inMinutes} min',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: AppColors.borderLight),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Fare',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '\$${widget.trip.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: [
                Icon(Icons.credit_card, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Visa •••• 4242',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Status',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Paid',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaction ID',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'TXN-${widget.trip.id.padLeft(8, '0')}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
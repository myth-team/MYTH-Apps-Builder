import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swipesense_finance_app/utils/colors.dart'; 
import 'package:swipesense_finance_app/main.dart';

class HomeScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onSwipeRight;
  final Function(Expense) onSwipeLeft;
  final VoidCallback onAddExpense;

  const HomeScreen({
    super.key,
    required this.expenses,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onAddExpense,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildStats(),
          Expanded(child: _buildSwiper()),
          _buildInstructions(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SwipeSense',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Swipe to categorize',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final goodCount = widget.expenses.where((e) => e.category == 'Good').length;
    final badCount = widget.expenses.where((e) => e.category == 'Bad').length;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Pending', widget.expenses.length.toString(), Icons.hourglass_empty_rounded),
            Container(width: 1, height: 40, color: Colors.white24),
            _buildStatItem('Good', goodCount.toString(), Icons.thumb_up_rounded),
            Container(width: 1, height: 40, color: Colors.white24),
            _buildStatItem('Bad', badCount.toString(), Icons.thumb_down_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSwiper() {
    if (widget.expenses.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: CardSwiper(
        controller: _controller,
        cardsCount: widget.expenses.length,
        numberOfCardsDisplayed: widget.expenses.length.clamp(1, 3),
        backCardOffset: const Offset(0, 40),
        padding: EdgeInsets.zero,
        onSwipe: (previousIndex, currentIndex, direction) {
          final expense = widget.expenses[previousIndex];
          if (direction == CardSwiperDirection.right) {
            widget.onSwipeRight(expense);
            _showSnackBar('Marked as Good Purchase!', AppColors.success);
          } else if (direction == CardSwiperDirection.left) {
            widget.onSwipeLeft(expense);
            _showSnackBar('Marked as Bad Purchase', AppColors.error);
          }
          return true;
        },
        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
          return _buildExpenseCard(widget.expenses[index], percentThresholdX);
        },
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense, double percentThreshold) {
    final isSwipingRight = percentThreshold > 0;
    final isSwipingLeft = percentThreshold < 0;
    final opacity = percentThreshold.abs() / 100;
    
    Color overlayColor = Colors.transparent;
    String overlayText = '';
    IconData overlayIcon = Icons.check_circle_rounded;
    
    if (isSwipingRight) {
      overlayColor = AppColors.success.withOpacity(opacity.clamp(0, 0.7));
      overlayText = 'GOOD';
      overlayIcon = Icons.thumb_up_rounded;
    } else if (isSwipingLeft) {
      overlayColor = AppColors.error.withOpacity(opacity.clamp(0, 0.7));
      overlayText = 'BAD';
      overlayIcon = Icons.thumb_down_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        expense.icon,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      expense.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = AppColors.primaryGradient.createShader(
                            const Rect.fromLTWH(0, 0, 200, 70),
                          ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        expense.category,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (overlayColor != Colors.transparent)
              Container(
                decoration: BoxDecoration(
                  color: overlayColor,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        overlayIcon,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        overlayText,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_card_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Expenses to Review',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your expenses and swipe to categorize them as good or bad purchases',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: widget.onAddExpense,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Expense'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Bad',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Good',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              message.contains('Good') ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
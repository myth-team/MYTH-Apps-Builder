import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_3_banking_forked_app/utils/colors.dart'; 
import 'package:web_3_banking_forked_app/widgets/receive_bottom_sheet.dart'; 
import 'package:web_3_banking_forked_app/widgets/send_bottom_sheet.dart'; 
import 'package:web_3_banking_forked_app/widgets/swap_bottom_sheet.dart'; 
import 'package:web_3_banking_forked_app/widgets/earn_bottom_sheet.dart'; 

class ActionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context,
          Icons.arrow_downward,
          'Receive',
          AppColors.success,
          () => _showReceiveBottomSheet(context),
        ),
        _buildActionButton(
          context,
          Icons.arrow_upward,
          'Send',
          AppColors.error,
          () => _showSendBottomSheet(context),
        ),
        _buildActionButton(
          context,
          Icons.swap_horiz,
          'Swap',
          AppColors.info,
          () => _showSwapBottomSheet(context),
        ),
        _buildActionButton(
          context,
          Icons.trending_up,
          'Earn',
          AppColors.yield,
          () => _showEarnBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReceiveBottomSheet(),
    );
  }

  void _showSendBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SendBottomSheet(),
    );
  }

  void _showSwapBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SwapBottomSheet(),
    );
  }

  void _showEarnBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => EarnBottomSheet(),
    );
  }
}
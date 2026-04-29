import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_3_banking_forked_app/utils/colors.dart'; 

class QuickAccessCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickCard(
                'Earning 4.2% APY',
                '500 USDC earning yield',
                Icons.trending_up,
                AppColors.yield,
                'Withdraw',
                () {},
              ),
              SizedBox(width: 16),
              _buildQuickCard(
                'IBAN Ready',
                'Share to receive payments',
                Icons.account_balance,
                AppColors.info,
                'Share',
                () {},
              ),
              SizedBox(width: 16),
              _buildQuickCard(
                'AAPL +3.2%',
                'Your investment is up today',
                Icons.show_chart,
                AppColors.success,
                'View',
                () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onPressed,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
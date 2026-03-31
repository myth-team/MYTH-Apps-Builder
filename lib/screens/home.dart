import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prompt_reader_pro_app/utils/colors.dart'; 

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 64),
              Text(
                'Hello Again, ',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Shahab',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Just tell MYTH what you imagine — we’ll take it from there.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryColor, width: 0.5),
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Just type what you want to build',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'MYTH v1.0 - Core',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                        Spacer(),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          child: Icon(Icons.send, color: AppColors.backgroundColor, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildExampleButton('Build a finance app'),
                    _buildExampleButton('Design for an ecommerce store'),
                    _buildExampleButton('Build a fitness app'),
                    _buildExampleButton('Create a calculator'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
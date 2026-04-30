import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_counter_app/models/counter_model.dart'; 
import 'package:simple_counter_app/utils/colors.dart'; 
import 'package:simple_counter_app/widgets/counter_display.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Simple Counter',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.surfaceColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: Consumer<CounterModel>(
          builder: (context, counter, child) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: CounterDisplay(count: counter.count),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Controls',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildControlButton(
                                icon: Icons.remove,
                                color: AppColors.secondaryColor,
                                onPressed: () => counter.decrement(),
                                label: 'Decrease',
                              ),
                              _buildControlButton(
                                icon: Icons.add,
                                color: AppColors.primaryColor,
                                onPressed: () => counter.increment(),
                                label: 'Increase',
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => counter.reset(),
                              icon: Icon(Icons.refresh),
                              label: Text('Reset Counter'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.warningColor,
                                foregroundColor: AppColors.textPrimary,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            iconSize: 32,
            color: color,
            padding: EdgeInsets.all(16),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
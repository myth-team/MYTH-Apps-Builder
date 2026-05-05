import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 

class FoodLogTile extends StatelessWidget {
  final String name;
  final int calories;
  final String? time;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  FoodLogTile({
    required this.name,
    required this.calories,
    this.time,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              _IconBox(),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (time != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          time!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$calories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                  onPressed: onDelete,
                  splashRadius: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.restaurant,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}
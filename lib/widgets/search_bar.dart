import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;
  final VoidCallback? onLocationTap;
  final VoidCallback? onDateTap;
  final TextEditingController? controller;

  CustomSearchBar({
    required this.hintText,
    required this.onSearch,
    this.onLocationTap,
    this.onDateTap,
    this.controller,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.grey500,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryGold,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: widget.onSearch,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.grey700,
          ),
          IconButton(
            onPressed: widget.onLocationTap,
            icon: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primaryGold,
            ),
            tooltip: 'Select Location',
          ),
          IconButton(
            onPressed: widget.onDateTap,
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primaryGold,
            ),
            tooltip: 'Select Dates',
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => widget.onSearch(_controller.text),
              icon: const Icon(
                Icons.arrow_forward,
                color: AppColors.primaryBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompactSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback onTap;

  CompactSearchBar({
    required this.hintText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.grey700,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.primaryGold,
            ),
            const SizedBox(width: 12),
            Text(
              hintText,
              style: const TextStyle(
                color: AppColors.grey500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/models/player.dart'; 
import 'package:tic_tac_toe_app/utils/colors.dart'; 

class CellWidget extends StatefulWidget {
  final PlayerSymbol? symbol;
  final bool isWinningCell;
  final VoidCallback onTap;
  final bool enabled;

  const CellWidget({
    super.key,
    required this.symbol,
    required this.isWinningCell,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    if (widget.symbol != null) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.symbol != null && oldWidget.symbol == null) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.enabled && widget.symbol == null ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _getCellColor(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.isWinningCell
                ? [
                    BoxShadow(
                      color: AppColors.winHighlight.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
            border: widget.isWinningCell
                ? Border.all(color: AppColors.winHighlight, width: 3)
                : null,
          ),
          child: Center(
            child: widget.symbol != null
                ? ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildSymbol(),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Color _getCellColor() {
    if (widget.isWinningCell) {
      return AppColors.winHighlight.withOpacity(0.3);
    }
    if (_isHovered && widget.symbol == null && widget.enabled) {
      return AppColors.cellHover;
    }
    return AppColors.cellEmpty;
  }

  Widget _buildSymbol() {
    final isX = widget.symbol == PlayerSymbol.x;
    final gradient = isX ? AppColors.playerXGradient : AppColors.playerOGradient;
    final color = isX ? AppColors.playerX : AppColors.playerO;
    final size = isX ? 48.0 : 52.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isX ? 'X' : 'O',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
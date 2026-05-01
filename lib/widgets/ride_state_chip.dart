import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

// ─────────────────────────────────────────────────────────────────────────────
// RideState enum — canonical, single declaration used across the whole project
// ─────────────────────────────────────────────────────────────────────────────

/// Represents all possible states of a ride in the system state machine.
enum RideState {
  /// Rider is selecting pickup / dropoff and has not yet requested.
  idle,

  /// Rider submitted a request; system is searching for a driver.
  matching,

  /// A driver accepted; awaiting driver arrival at pickup.
  driverAssigned,

  /// Driver has arrived at the pickup point.
  driverArrived,

  /// Trip is in progress — driver en route to destination.
  active,

  /// Trip completed; awaiting rating.
  completed,

  /// Ride was cancelled by rider or driver.
  cancelled,

  /// Fare payment failed.
  paymentFailed,

  /// No driver found within timeout.
  noDriverFound,
}

// ─────────────────────────────────────────────────────────────────────────────
// RideStateChip — visual status badge widget
// ─────────────────────────────────────────────────────────────────────────────

/// A compact, animated status chip that reflects the current [RideState].
///
/// Used on the rider tracking screen (ETA chip area), driver home screen
/// (status indicator), and anywhere else a ride status needs to be displayed.
class RideStateChip extends StatefulWidget {
  final RideState state;

  /// When true, shows a pulse/blink animation for transient states.
  final bool animated;

  /// Optional compact mode — shows only the dot + short label, no description.
  final bool compact;

  /// Custom label override — defaults to the state's canonical label.
  final String? labelOverride;

  const RideStateChip({
    Key? key,
    required this.state,
    this.animated = true,
    this.compact = false,
    this.labelOverride,
  }) : super(key: key);

  @override
  State<RideStateChip> createState() => _RideStateChipState();
}

class _RideStateChipState extends State<RideStateChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );
    _maybeStartAnimation();
  }

  @override
  void didUpdateWidget(RideStateChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state ||
        oldWidget.animated != widget.animated) {
      _blinkController.stop();
      _maybeStartAnimation();
    }
  }

  void _maybeStartAnimation() {
    if (widget.animated && _isTransientState(widget.state)) {
      _blinkController.repeat(reverse: true);
    }
  }

  bool _isTransientState(RideState state) {
    return state == RideState.matching ||
        state == RideState.driverAssigned ||
        state == RideState.driverArrived ||
        state == RideState.active;
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _ChipConfig.forState(widget.state);
    final String label = widget.labelOverride ?? config.label;

    if (widget.compact) {
      return _buildCompactChip(config, label);
    }
    return _buildFullChip(config, label);
  }

  Widget _buildCompactChip(_ChipConfig config, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config.accentColor.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(config),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: config.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullChip(_ChipConfig config, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: config.accentColor.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: config.accentColor.withOpacity(0.12),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(config),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: config.accentColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              if (config.description != null) ...[
                SizedBox(height: 2),
                Text(
                  config.description!,
                  style: TextStyle(
                    color: config.accentColor.withOpacity(0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(width: 6),
          _buildStateIcon(config),
        ],
      ),
    );
  }

  Widget _buildDot(_ChipConfig config) {
    final bool shouldBlink =
        widget.animated && _isTransientState(widget.state);

    if (shouldBlink) {
      return AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, _) {
          return _Dot(
            color: config.accentColor,
            opacity: _blinkAnimation.value,
            size: 8,
          );
        },
      );
    }
    return _Dot(
      color: config.accentColor,
      opacity: 1.0,
      size: 8,
    );
  }

  Widget _buildStateIcon(_ChipConfig config) {
    return Icon(
      config.icon,
      color: config.accentColor,
      size: 16,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Animated dot indicator
// ─────────────────────────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  final Color color;
  final double opacity;
  final double size;

  const _Dot({
    required this.color,
    required this.opacity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: size,
              spreadRadius: size * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Chip configuration data object
// ─────────────────────────────────────────────────────────────────────────────

class _ChipConfig {
  final String label;
  final String? description;
  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;

  const _ChipConfig({
    required this.label,
    this.description,
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
  });

  factory _ChipConfig.forState(RideState state) {
    switch (state) {
      case RideState.idle:
        return _ChipConfig(
          label: 'Ready',
          description: 'Set your destination',
          accentColor: AppColors.grey500,
          backgroundColor: AppColors.grey100,
          icon: Icons.location_searching_rounded,
        );

      case RideState.matching:
        return _ChipConfig(
          label: 'Finding Driver',
          description: 'Looking for nearby drivers…',
          accentColor: AppColors.warning,
          backgroundColor: AppColors.warningSurface,
          icon: Icons.search_rounded,
        );

      case RideState.driverAssigned:
        return _ChipConfig(
          label: 'Driver Assigned',
          description: 'Your driver is on the way',
          accentColor: AppColors.primary,
          backgroundColor: AppColors.primarySurface,
          icon: Icons.directions_car_rounded,
        );

      case RideState.driverArrived:
        return _ChipConfig(
          label: 'Driver Arrived',
          description: 'Your driver is waiting',
          accentColor: AppColors.tertiary,
          backgroundColor: AppColors.tertiarySurface,
          icon: Icons.where_to_vote_rounded,
        );

      case RideState.active:
        return _ChipConfig(
          label: 'On Trip',
          description: 'En route to destination',
          accentColor: AppColors.success,
          backgroundColor: AppColors.successSurface,
          icon: Icons.navigation_rounded,
        );

      case RideState.completed:
        return _ChipConfig(
          label: 'Completed',
          description: 'You have arrived!',
          accentColor: AppColors.info,
          backgroundColor: AppColors.infoSurface,
          icon: Icons.check_circle_rounded,
        );

      case RideState.cancelled:
        return _ChipConfig(
          label: 'Cancelled',
          description: 'Ride was cancelled',
          accentColor: AppColors.error,
          backgroundColor: AppColors.errorSurface,
          icon: Icons.cancel_rounded,
        );

      case RideState.paymentFailed:
        return _ChipConfig(
          label: 'Payment Failed',
          description: 'Please update your payment',
          accentColor: AppColors.error,
          backgroundColor: AppColors.errorSurface,
          icon: Icons.payment_rounded,
        );

      case RideState.noDriverFound:
        return _ChipConfig(
          label: 'No Driver Found',
          description: 'Please try again',
          accentColor: AppColors.grey600,
          backgroundColor: AppColors.grey100,
          icon: Icons.car_crash_rounded,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Public: DriverStatusChip — specific to driver online/offline state
// ─────────────────────────────────────────────────────────────────────────────

/// Describes the driver's availability mode.
enum DriverAvailability { online, offline, busy }

/// A pill-shaped status chip for the driver home screen's status indicator.
class DriverStatusChip extends StatefulWidget {
  final DriverAvailability status;
  final bool animated;
  final bool compact;

  const DriverStatusChip({
    Key? key,
    required this.status,
    this.animated = true,
    this.compact = false,
  }) : super(key: key);

  @override
  State<DriverStatusChip> createState() => _DriverStatusChipState();
}

class _DriverStatusChipState extends State<DriverStatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _maybeAnimate();
  }

  @override
  void didUpdateWidget(DriverStatusChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.stop();
    _maybeAnimate();
  }

  void _maybeAnimate() {
    if (widget.animated && widget.status == DriverAvailability.online) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accent {
    switch (widget.status) {
      case DriverAvailability.online:
        return AppColors.onlineStatus;
      case DriverAvailability.offline:
        return AppColors.offlineStatus;
      case DriverAvailability.busy:
        return AppColors.busyStatus;
    }
  }

  Color get _background {
    switch (widget.status) {
      case DriverAvailability.online:
        return AppColors.successSurface;
      case DriverAvailability.offline:
        return AppColors.grey100;
      case DriverAvailability.busy:
        return AppColors.warningSurface;
    }
  }

  String get _label {
    switch (widget.status) {
      case DriverAvailability.online:
        return 'Online';
      case DriverAvailability.offline:
        return 'Offline';
      case DriverAvailability.busy:
        return 'On Trip';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool pulsing =
        widget.animated && widget.status == DriverAvailability.online;
    final double dotSize = widget.compact ? 7.0 : 9.0;
    final double fontSize = widget.compact ? 11.0 : 13.0;
    final EdgeInsets padding = widget.compact
        ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        : EdgeInsets.symmetric(horizontal: 14, vertical: 8);

    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      padding: padding,
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _accent.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          pulsing
              ? AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, _) {
                    return _Dot(
                      color: _accent,
                      opacity: _pulseAnim.value,
                      size: dotSize,
                    );
                  },
                )
              : _Dot(color: _accent, opacity: 1.0, size: dotSize),
          SizedBox(width: 6),
          Text(
            _label,
            style: TextStyle(
              color: _accent,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
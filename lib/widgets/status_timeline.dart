import 'package:flutter/material.dart';
import 'package:ride_now_app/utils/colors.dart'; 

enum RideStatus {
  requested,
  accepted,
  arriving,
  onTrip,
  completed,
}

class StatusTimeline extends StatelessWidget {
  final RideStatus currentStatus;
  final List<String>? customLabels;

  StatusTimeline({required this.currentStatus, this.customLabels});

  List<String> get _labels =>
      customLabels ??
      ['Requested', 'Accepted', 'Arriving', 'On Trip', 'Completed'];

  List<IconData> get _icons => [
        Icons.touch_app,
        Icons.check_circle,
        Icons.local_taxi,
        Icons.navigation,
        Icons.done_all,
      ];

  int get _currentIndex => RideStatus.values.indexOf(currentStatus);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: _buildTimelineDots(),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_labels.length, (i) {
            final isActive = i <= _currentIndex;
            return SizedBox(
              width: 64,
              child: Text(
                _labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  List<Widget> _buildTimelineDots() {
    final items = <Widget>[];
    for (int i = 0; i < _labels.length; i++) {
      final isActive = i <= _currentIndex;
      final isCurrent = i == _currentIndex;

      items.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: isCurrent ? 40 : 32,
              height: isCurrent ? 40 : 32,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.divider,
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 4)
                    : null,
              ),
              child: Icon(
                _icons[i],
                size: isCurrent ? 20 : 16,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );

      if (i < _labels.length - 1) {
        items.add(
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 3,
              margin: EdgeInsets.symmetric(horizontal: 4),
              color: i < _currentIndex ? AppColors.primary : AppColors.divider,
            ),
          ),
        );
      }
    }
    return items;
  }
}

class AnimatedStatusTimeline extends StatefulWidget {
  final Stream<RideStatus> statusStream;
  final List<String>? customLabels;

  AnimatedStatusTimeline({required this.statusStream, this.customLabels});

  @override
  _AnimatedStatusTimelineState createState() => _AnimatedStatusTimelineState();
}

class _AnimatedStatusTimelineState extends State<AnimatedStatusTimeline> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RideStatus>(
      stream: widget.statusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? RideStatus.requested;
        return StatusTimeline(
          currentStatus: status,
          customLabels: widget.customLabels,
        );
      },
    );
  }
}
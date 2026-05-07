import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylebook_salon_app/providers/app_state.dart';
import 'package:stylebook_salon_app/utils/colors.dart'; 
import 'package:stylebook_salon_app/widgets/service_card.dart'; 
import 'package:stylebook_salon_app/widgets/stylist_avatar.dart'; 

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;
  String? _selectedServiceId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStylistId;

  @override
  Widget build(BuildContext context) {
    final preselectedStylistId = ModalRoute.of(context)!.settings.arguments as String?;
    if (preselectedStylistId != null && _selectedStylistId == null) {
      _selectedStylistId = preselectedStylistId;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _canContinue() ? _nextStep : null,
          onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentStep == 3 ? 'Confirm Booking' : 'Continue'),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Service'),
              content: _ServiceStep(
                selectedId: _selectedServiceId,
                onSelect: (id) => setState(() => _selectedServiceId = id),
              ),
              isActive: _currentStep >= 0,
              state: _selectedServiceId != null ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Date & Time'),
              content: _DateTimeStep(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelect: (d) => setState(() => _selectedDate = d),
                onTimeSelect: (t) => setState(() => _selectedTime = t),
              ),
              isActive: _currentStep >= 1,
              state: _selectedDate != null && _selectedTime != null
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text('Stylist'),
              content: _StylistStep(
                selectedId: _selectedStylistId,
                onSelect: (id) => setState(() => _selectedStylistId = id),
              ),
              isActive: _currentStep >= 2,
              state: _selectedStylistId != null ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Confirm'),
              content: _currentStep == 3
                  ? _ConfirmStep(
                      serviceId: _selectedServiceId!,
                      date: _selectedDate!,
                      time: _selectedTime!,
                      stylistId: _selectedStylistId!,
                    )
                  : const SizedBox.shrink(),
              isActive: _currentStep >= 3,
            ),
          ],
        ),
      ),
    );
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _selectedServiceId != null;
      case 1:
        return _selectedDate != null && _selectedTime != null;
      case 2:
        return _selectedStylistId != null;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep == 3) {
      _confirmBooking();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _confirmBooking() {
    final appState = context.read<AppState>();
    final service = appState.services.firstWhere((s) => s.id == _selectedServiceId);
    final stylist = appState.stylists.firstWhere((s) => s.id == _selectedStylistId);
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      stylistId: stylist.id,
      stylistName: stylist.name,
      serviceName: service.name,
      dateTime: dateTime,
      price: service.price,
    );

    appState.addBooking(booking);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 12),
            Text('Booked!'),
          ],
        ),
        content: Text('Your ${service.name} with ${stylist.name} is confirmed for ${_formatDateTime(dateTime)}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              appState.setCurrentTab(1);
            },
            child: const Text('View My Bookings'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final am = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$m/$d at $h:$min $am';
  }
}

class _ServiceStep extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _ServiceStep({required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final services = context.watch<AppState>().services;
    return Column(
      children: services.map((s) => ServiceCard(
        name: s.name,
        description: s.description,
        price: s.price,
        durationMinutes: s.durationMinutes,
        isSelected: selectedId == s.id,
        onTap: () => onSelect(s.id),
      )).toList(),
    );
  }
}

class _DateTimeStep extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onDateSelect;
  final ValueChanged<TimeOfDay> onTimeSelect;

  const _DateTimeStep({
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelect,
    required this.onTimeSelect,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dates = List.generate(14, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Date', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = selectedDate?.day == date.day &&
                  selectedDate?.month == date.month;
              return InkWell(
                onTap: () => onDateSelect(date),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text('Select Time', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['9:00 AM', '10:30 AM', '12:00 PM', '2:00 PM', '3:30 PM', '5:00 PM']
              .map((t) {
            final isSelected = selectedTime != null &&
                '${selectedTime!.hourOfPeriod}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period.name.toUpperCase()}' == t;
            return ChoiceChip(
              label: Text(t),
              selected: isSelected,
              onSelected: (_) {
                final parts = t.split(' ');
                final hm = parts[0].split(':');
                final hour = int.parse(hm[0]) + (parts[1] == 'PM' && hm[0] != '12' ? 12 : 0);
                onTimeSelect(TimeOfDay(hour: hour, minute: int.parse(hm[1])));
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StylistStep extends StatefulWidget {
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _StylistStep({required this.selectedId, required this.onSelect});

  @override
  State<_StylistStep> createState() => _StylistStepState();
}

class _StylistStepState extends State<_StylistStep> {
  String? _localSelectedId;

  @override
  void initState() {
    super.initState();
    _localSelectedId = widget.selectedId;
  }

  @override
  void didUpdateWidget(covariant _StylistStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != oldWidget.selectedId) {
      _localSelectedId = widget.selectedId;
    }
  }

  void _handleSelect(String? value) {
    if (value == null) return;
    setState(() => _localSelectedId = value);
    widget.onSelect(value);
  }

  @override
  Widget build(BuildContext context) {
    final stylists = context.watch<AppState>().stylists;
    final options = [
      {'id': 'any', 'name': 'No preference', 'subtitle': 'We\'ll match you with the best available stylist', 'imageUrl': null},
      ...stylists.map((s) => {'id': s.id, 'name': s.name, 'subtitle': s.specialties.join(' • '), 'imageUrl': s.imageUrl}),
    ];
    
    return Column(
      children: options.map((opt) {
        final isSelected = _localSelectedId == opt['id'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => _handleSelect(opt['id']),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
              ),
              child: Row(
                children: [
                  if (opt['id'] != 'any')
                    StylistAvatar(name: opt['name']!, imageUrl: opt['imageUrl'], size: 48),
                  if (opt['id'] != 'any') const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opt['name']!, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.primaryDark : AppColors.textPrimary)),
                        Text(opt['subtitle']!, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: AppColors.primary),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ConfirmStep extends StatelessWidget {
  final String serviceId;
  final DateTime date;
  final TimeOfDay time;
  final String stylistId;

  const _ConfirmStep({
    required this.serviceId,
    required this.date,
    required this.time,
    required this.stylistId,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final service = appState.services.firstWhere((s) => s.id == serviceId);
    final stylist = stylistId == 'any'
        ? null
        : appState.stylists.firstWhere((s) => s.id == stylistId);

    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = time.hour > 12 ? time.hour - 12 : time.hour;
    final am = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfirmRow('Service', service.name),
            _ConfirmRow('Date', '$m/$d/${date.year}'),
            _ConfirmRow('Time', '$h:$min $am'),
            _ConfirmRow('Stylist', stylist?.name ?? 'Best available'),
            const Divider(height: 24),
            _ConfirmRow('Duration', '${service.durationMinutes} min'),
            _ConfirmRow('Price', '\$${service.price.toStringAsFixed(0)}',
                isTotal: true),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _ConfirmRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
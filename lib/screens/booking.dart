import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styleme_salon_app/utils/colors.dart'; 

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;
  String? _selectedService;
  String? _selectedStylist;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<Map<String, dynamic>> _services = [
    {'name': 'Haircut & Style', 'desc': 'Classic cut with styling', 'price': 45.0, 'icon': Icons.content_cut},
    {'name': 'Hair Coloring', 'desc': 'Full color treatment', 'price': 120.0, 'icon': Icons.palette},
    {'name': 'Highlights', 'desc': 'Partial or full highlights', 'price': 150.0, 'icon': Icons.auto_awesome},
    {'name': 'Blow Dry', 'desc': 'Professional blow dry', 'price': 35.0, 'icon': Icons.air},
    {'name': 'Deep Conditioning', 'desc': 'Moisturizing treatment', 'price': 40.0, 'icon': Icons.spa},
    {'name': 'Bridal Styling', 'desc': 'Wedding day hairstyle', 'price': 200.0, 'icon': Icons.bride},
  ];

  final List<Map<String, dynamic>> _stylists = [
    {'name': 'Sarah Miller', 'specialty': 'Color Expert', 'rating': 4.9, 'avatar': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'James Wilson', 'specialty': 'Precision Cuts', 'rating': 4.8, 'avatar': 'https://i.pravatar.cc/150?img=3'},
    {'name': 'Emily Chen', 'specialty': 'Bridal Specialist', 'rating': 5.0, 'avatar': 'https://i.pravatar.cc/150?img=5'},
    {'name': 'Mike Brown', 'specialty': 'Textured Hair', 'rating': 4.7, 'avatar': 'https://i.pravatar.cc/150?img=8'},
  ];

  final List<String> _timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM',
  ];

  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _showConfirmation();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Booking Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            const SizedBox(height: 16),
            Text('Service: $_selectedService'),
            Text('Stylist: $_selectedStylist'),
            Text('Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
            Text('Time: $_selectedTimeSlot'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/my_appointments');
            },
            child: const Text('View My Appointments'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentStep == 2 ? 'Confirm' : 'Continue'),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Select Service'),
            content: _buildServiceSelection(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Choose Stylist & Date'),
            content: _buildStylistAndDateSelection(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Pick Time Slot'),
            content: _buildTimeSlotSelection(),
            isActive: _currentStep >= 2,
            state: _currentStep == 2 ? StepState.indexed : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      children: _services.map((service) {
        final isSelected = _selectedService == service['name'];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected ? AppColors.primaryLight.withOpacity(0.1) : null,
          child: ListTile(
            leading: Icon(service['icon'], color: AppColors.primary),
            title: Text(service['name']),
            subtitle: Text(service['desc']),
            trailing: Text('\$${service['price'].toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            selected: isSelected,
            onTap: () => setState(() => _selectedService = service['name']),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStylistAndDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Stylist', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _stylists.length,
            itemBuilder: (context, index) {
              final stylist = _stylists[index];
              final isSelected = _selectedStylist == stylist['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedStylist = stylist['name']),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(stylist['avatar']),
                      ),
                      const SizedBox(height: 4),
                      Text(stylist['name'].split(' ').first,
                          style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          overflow: TextOverflow.ellipsis),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 12, color: AppColors.starFilled),
                          Text('${stylist['rating']}', style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
          child: Text(_selectedDate != null
              ? DateFormat.yMMMd().format(_selectedDate!)
              : 'Tap to select date'),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Time Slots', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : null),
              onSelected: (selected) {
                if (selected) setState(() => _selectedTimeSlot = slot);
              },
            );
          }).toList(),
        ),
        if (_selectedService != null && _selectedStylist != null && _selectedDate != null && _selectedTimeSlot != null) ...[
          const SizedBox(height: 24),
          Card(
            color: AppColors.primaryLight.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  Text('Service: $_selectedService'),
                  Text('Stylist: $_selectedStylist'),
                  Text('Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
                  Text('Time: $_selectedTimeSlot'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
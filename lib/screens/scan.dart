import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/screens/home.dart'; 

class ScanTab extends StatefulWidget {
  final Function(String, int) onAdd;

  ScanTab({required this.onAdd});

  @override
  _ScanTabState createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  bool _scanning = false;
  bool _scanned = false;
  String _foodName = '';
  int _calories = 0;
  File? _image;

  final List<Map<String, dynamic>> _mockResults = [
    {'name': 'Grilled salmon with vegetables', 'calories': 520},
    {'name': 'Caesar salad with chicken', 'calories': 480},
    {'name': 'Avocado toast with egg', 'calories': 390},
    {'name': 'Chicken burrito bowl', 'calories': 650},
  ];

  Future<void> _capture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _scanning = true;
      _scanned = false;
    });

    await Future.delayed(Duration(seconds: 2));

    final result = _mockResults[DateTime.now().millisecond % _mockResults.length];
    setState(() {
      _scanning = false;
      _scanned = true;
      _foodName = result['name'];
      _calories = result['calories'];
    });
  }

  void _reset() {
    setState(() {
      _scanning = false;
      _scanned = false;
      _image = null;
    });
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.white70),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Food Scanner',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacer(),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  void _addToToday() {
    widget.onAdd(_foodName, _calories);
    _reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $_foodName ($_calories kcal)'), backgroundColor: AppColors.secondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _buildViewfinder(),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewfinder() {
    if (_scanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            SizedBox(height: 24),
            Text('Analyzing food...', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      );
    }

    if (_scanned) {
      return _buildResult();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black87),
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 64, color: Colors.white54),
                SizedBox(height: 16),
                Text('Align food in frame', style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
        ),
        if (_image != null)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
      ],
    );
  }

  Widget _buildResult() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 56, color: AppColors.success),
          ),
          SizedBox(height: 32),
          Text(
            'Detected:',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            _foodName,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_calories',
                style: TextStyle(color: AppColors.primary, fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text('kcal', style: TextStyle(color: Colors.white70, fontSize: 20)),
            ],
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _addToToday,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text('Add to Today', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: _reset,
            child: Text('Scan Again', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    if (_scanning || _scanned) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _capture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.transparent,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
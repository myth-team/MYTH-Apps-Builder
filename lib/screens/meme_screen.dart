import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_stream_app/utils/colors.dart'; 
import 'package:meme_stream_app/widgets/meme_card.dart'; 
import 'package:meme_stream_app/widgets/gradient_button.dart'; 
import 'package:meme_stream_app/widgets/loading_shimmer.dart'; 

class MemeScreen extends StatefulWidget {
  const MemeScreen({super.key});

  @override
  State<MemeScreen> createState() => _MemeScreenState();
}

class _MemeScreenState extends State<MemeScreen> with SingleTickerProviderStateMixin {
  String? _currentMemeUrl;
  String? _currentMemeTitle;
  bool _isLoading = false;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _placeholderMemes = [
    'https://i.imgflip.com/1bij.jpg',
    'https://i.imgflip.com/1ur9b0.jpg',
    'https://i.imgflip.com/24y43o.jpg',
    'https://i.imgflip.com/1ihzfe.jpg',
    'https://i.imgflip.com/2fm6x.jpg',
    'https://i.imgflip.com/30b1pu.jpg',
    'https://i.imgflip.com/1otk96.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _fetchRandomMeme();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchRandomMeme() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.imgflip.com/get_memes'),
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final memes = data['data']['memes'] as List;
          final random = Random();
          final randomMeme = memes[random.nextInt(memes.length)];
          
          setState(() {
            _currentMemeUrl = randomMeme['url'];
            _currentMemeTitle = randomMeme['name'];
            _isLoading = false;
          });
          _animationController.reset();
          _animationController.forward();
        } else {
          _loadPlaceholder();
        }
      } else {
        _loadPlaceholder();
      }
    } catch (e) {
      _loadPlaceholder();
    }
  }

  void _loadPlaceholder() {
    final random = Random();
    setState(() {
      _currentMemeUrl = _placeholderMemes[random.nextInt(_placeholderMemes.length)];
      _currentMemeTitle = 'Random Meme';
      _isLoading = false;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _onTap() {
    _fetchRandomMeme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: GestureDetector(
                onTap: _onTap,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: _buildMemeContent(),
                  ),
                ),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MemeStream',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Tap for random laughs',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemeContent() {
    if (_isLoading) {
      return const LoadingShimmer();
    }

    if (_currentMemeUrl == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
        ],
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MemeCard(
          imageUrl: _currentMemeUrl!,
          title: _currentMemeTitle,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          GradientButton(
            onPressed: _onTap,
            text: 'Get New Meme',
            icon: Icons.refresh,
          ),
          const SizedBox(height: 16),
          Text(
            'Tap anywhere above for a new meme',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
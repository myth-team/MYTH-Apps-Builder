import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models
// ─────────────────────────────────────────────────────────────────────────────

enum UserRole { rider, driver, none }

enum AuthStatus {
  unauthenticated,
  otpSent,
  otpVerified,
  profileIncomplete,
  authenticated,
  loading,
  error,
}

class UserProfile {
  final String uid;
  final String phone;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final UserRole role;
  final double walletBalance;
  final bool isDocumentVerified;
  final String? vehicleType;
  final String? vehiclePlate;

  const UserProfile({
    required this.uid,
    required this.phone,
    this.name,
    this.email,
    this.avatarUrl,
    required this.role,
    this.walletBalance = 0.0,
    this.isDocumentVerified = false,
    this.vehicleType,
    this.vehiclePlate,
  });

  UserProfile copyWith({
    String? uid,
    String? phone,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    double? walletBalance,
    bool? isDocumentVerified,
    String? vehicleType,
    String? vehiclePlate,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      walletBalance: walletBalance ?? this.walletBalance,
      isDocumentVerified: isDocumentVerified ?? this.isDocumentVerified,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role.name,
      'walletBalance': walletBalance,
      'isDocumentVerified': isDocumentVerified,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      name: map['name'] as String?,
      email: map['email'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      role: _roleFromString(map['role'] as String?),
      walletBalance: (map['walletBalance'] as num?)?.toDouble() ?? 0.0,
      isDocumentVerified: map['isDocumentVerified'] as bool? ?? false,
      vehicleType: map['vehicleType'] as String?,
      vehiclePlate: map['vehiclePlate'] as String?,
    );
  }

  static UserRole _roleFromString(String? value) {
    switch (value) {
      case 'rider':
        return UserRole.rider;
      case 'driver':
        return UserRole.driver;
      default:
        return UserRole.none;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthProvider
// ─────────────────────────────────────────────────────────────────────────────

class AuthProvider extends ChangeNotifier {
  // ── State fields ──────────────────────────────────────────────────────────
  AuthStatus _status = AuthStatus.unauthenticated;
  UserProfile? _currentUser;
  String? _errorMessage;
  String? _pendingPhone;
  String? _verificationId;

  // OTP countdown
  Timer? _otpTimer;
  int _otpSecondsRemaining = 0;
  static const int _otpTimeoutSeconds = 60;

  // Social auth loading flags
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  // ── Public getters ────────────────────────────────────────────────────────
  AuthStatus get status => _status;
  UserProfile? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  String? get pendingPhone => _pendingPhone;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isAppleLoading => _isAppleLoading;
  int get otpSecondsRemaining => _otpSecondsRemaining;
  bool get isOtpCountdownActive => _otpSecondsRemaining > 0;
  UserRole get userRole => _currentUser?.role ?? UserRole.none;
  bool get isRider => _currentUser?.role == UserRole.rider;
  bool get isDriver => _currentUser?.role == UserRole.driver;
  double get walletBalance => _currentUser?.walletBalance ?? 0.0;
  bool get isProfileComplete => _currentUser?.name != null &&
      (_currentUser?.name?.isNotEmpty ?? false);

  // ── Phone / OTP Authentication ────────────────────────────────────────────

  /// Initiates phone OTP verification. Simulates network call.
  Future<void> sendOtp({
    required String phoneNumber,
    required UserRole role,
  }) async {
    _setLoading();
    _pendingPhone = phoneNumber;
    _errorMessage = null;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1200));

      // In production: call Firebase/backend OTP service
      // _verificationId = await AuthService.sendOtp(phoneNumber);
      _verificationId = 'mock_verification_id_${DateTime.now().millisecondsSinceEpoch}';

      _status = AuthStatus.otpSent;
      _startOtpCountdown();
      notifyListeners();
    } catch (e) {
      _setError('Failed to send OTP. Please try again.');
    }
  }

  /// Verifies the OTP entered by the user.
  Future<bool> verifyOtp({
    required String otp,
    required UserRole role,
  }) async {
    if (_verificationId == null) {
      _setError('Verification session expired. Please resend OTP.');
      return false;
    }

    _setLoading();
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(milliseconds: 900));

      // In production: verify with Firebase/backend
      // final result = await AuthService.verifyOtp(_verificationId!, otp);
      final bool isValid = otp.length == 6; // Mock: any 6-digit OTP passes

      if (isValid) {
        _otpTimer?.cancel();
        _status = AuthStatus.otpVerified;

        // Simulate fetching user profile
        _currentUser = UserProfile(
          uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
          phone: _pendingPhone ?? '',
          role: role,
          walletBalance: role == UserRole.rider ? 125.50 : 0.0,
        );

        final bool profileExists = false; // Mock: new user
        if (profileExists) {
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.profileIncomplete;
        }

        notifyListeners();
        return true;
      } else {
        _setError('Invalid OTP. Please check and try again.');
        return false;
      }
    } catch (e) {
      _setError('Verification failed. Please try again.');
      return false;
    }
  }

  /// Resends OTP to the pending phone number.
  Future<void> resendOtp({required UserRole role}) async {
    if (_pendingPhone == null) return;
    _otpTimer?.cancel();
    _otpSecondsRemaining = 0;
    notifyListeners();
    await sendOtp(phoneNumber: _pendingPhone!, role: role);
  }

  // ── Social Authentication ─────────────────────────────────────────────────

  /// Signs in with Google. Simulates OAuth flow.
  Future<bool> signInWithGoogle({required UserRole role}) async {
    _isGoogleLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      // In production: GoogleSignIn().signIn() + Firebase credential
      _currentUser = UserProfile(
        uid: 'google_uid_${DateTime.now().millisecondsSinceEpoch}',
        phone: '',
        name: 'Alex Johnson',
        email: 'alex.johnson@gmail.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        role: role,
        walletBalance: role == UserRole.rider ? 250.00 : 0.0,
      );

      _status = AuthStatus.authenticated;
      _isGoogleLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isGoogleLoading = false;
      _setError('Google sign-in failed. Please try again.');
      return false;
    }
  }

  /// Signs in with Apple. Simulates OAuth flow.
  Future<bool> signInWithApple({required UserRole role}) async {
    _isAppleLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      // In production: SignInWithApple.getAppleIDCredential() + Firebase
      _currentUser = UserProfile(
        uid: 'apple_uid_${DateTime.now().millisecondsSinceEpoch}',
        phone: '',
        name: 'Apple User',
        email: null,
        avatarUrl: null,
        role: role,
        walletBalance: role == UserRole.rider ? 100.00 : 0.0,
      );

      _status = AuthStatus.authenticated;
      _isAppleLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isAppleLoading = false;
      _setError('Apple sign-in failed. Please try again.');
      return false;
    }
  }

  // ── Profile Setup ─────────────────────────────────────────────────────────

  /// Completes the user profile (for new users or drivers).
  Future<bool> completeProfile({
    required String name,
    String? email,
    String? vehicleType,
    String? vehiclePlate,
    bool isDocumentVerified = false,
  }) async {
    if (_currentUser == null) {
      _setError('No user session found.');
      return false;
    }

    _setLoading();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        vehicleType: vehicleType,
        vehiclePlate: vehiclePlate,
        isDocumentVerified: isDocumentVerified,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save profile. Please try again.');
      return false;
    }
  }

  // ── Wallet ────────────────────────────────────────────────────────────────

  /// Updates the wallet balance (e.g., after a payment or top-up).
  void updateWalletBalance(double newBalance) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(walletBalance: newBalance);
    notifyListeners();
  }

  /// Deducts an amount from the wallet. Returns true if successful.
  bool deductFromWallet(double amount) {
    if (_currentUser == null) return false;
    if (_currentUser!.walletBalance < amount) return false;
    _currentUser = _currentUser!.copyWith(
      walletBalance: _currentUser!.walletBalance - amount,
    );
    notifyListeners();
    return true;
  }

  /// Adds funds to the wallet.
  void topUpWallet(double amount) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      walletBalance: _currentUser!.walletBalance + amount,
    );
    notifyListeners();
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────

  /// Signs out the current user and resets all state.
  Future<void> signOut() async {
    _otpTimer?.cancel();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    _pendingPhone = null;
    _verificationId = null;
    _otpSecondsRemaining = 0;
    _isGoogleLoading = false;
    _isAppleLoading = false;
    notifyListeners();
  }

  // ── Error Management ──────────────────────────────────────────────────────

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _currentUser != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // ── Mock: Restore session (call on app launch) ─────────────────────────────

  /// Attempts to restore a cached session on app startup.
  Future<void> restoreSession() async {
    _setLoading();
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // In production: load from secure storage / Hive / SharedPreferences
      // For now, simulate no saved session
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _setLoading() {
    _status = AuthStatus.loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    _isGoogleLoading = false;
    _isAppleLoading = false;
    notifyListeners();
  }

  void _startOtpCountdown() {
    _otpSecondsRemaining = _otpTimeoutSeconds;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpSecondsRemaining <= 0) {
        timer.cancel();
        notifyListeners();
        return;
      }
      _otpSecondsRemaining--;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    super.dispose();
  }
}
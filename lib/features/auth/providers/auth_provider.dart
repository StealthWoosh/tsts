import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/auth/data/auth_services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruang_sehat/features/auth/data/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  UserModel? get profile => _profile;

  // Provider Register
  Future<bool> register(String name, String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await AuthServices.register(name, username, password);
      final data = jsonDecode(response.body);

      if (data['sucess'] == true) {
        _successMessage = data['message'] ?? 'Registrasi berhasil';
        return true;
      } else {
        if (data['errors'] != null && data['errors'].length > 0) {
          final firstError = data['errors'][0];
          _errorMessage = firstError['message'];
        } else {
          _errorMessage = data['message'] ?? 'Terjadi Kesalahan';
        }
        return false;
      }
    } catch (error) {
      _errorMessage = 'Terjadi Kesalahan Koneksi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Provider Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await AuthServices.login(username, password);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final token = data['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        _successMessage = data['message'] ?? 'Login berhasil';
        return true;
      } else {
        if (data['errors'] != null && data['errors'].length > 0) {
          final firstError = data['errors'][0];
          _errorMessage = firstError['message'];
        } else {
          _errorMessage = data['message'] ?? 'Terjadi Kesalahan';
        }
        return false;
      }
    } catch (error) {
      _errorMessage = 'Terjadi Kesalahan Koneksi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Provider Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'Token tidak ditemukan';
      notifyListeners();
      return;
    }

    final response = await AuthServices.logout();

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await prefs.remove('token');
      _successMessage = data['message'] ?? 'Logout berhasil';
    } else {
      _errorMessage = data['message'] ?? 'Terjadi kesalahan';
    }

    notifyListeners();
  }

  // Provider Get Profile
  Future<void> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'Token tidak ditemukan';
      notifyListeners();
      return;
    }

    try {
      final result = await AuthServices.getProfile();
      _profile = result;
      _successMessage = 'Profile berhasil diambil';
    } catch (e) {
      _errorMessage = e.toString();
    }

    notifyListeners();
  }
}
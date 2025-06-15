import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'profile_screen.dart';
import 'register_page.dart';

class ProtectedProfileWrapper extends StatefulWidget {
  const ProtectedProfileWrapper({Key? key}) : super(key: key);

  @override
  State<ProtectedProfileWrapper> createState() =>
      _ProtectedProfileWrapperState();
}

class _ProtectedProfileWrapperState extends State<ProtectedProfileWrapper> {
  bool _isLoggedIn = false;
  bool _loading = true;
  bool _showingLogin = true; // Track whether showing login or register

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _loading = false;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _navigateToRegister() {
    setState(() {
      _showingLogin = false;
    });
  }

  void _navigateToLogin() {
    setState(() {
      _showingLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_isLoggedIn) {
      return ProfileScreen(onLogout: () => setState(() => _isLoggedIn = false));
    } else {
      return _showingLogin
          ? LoginPage(
              onLoginSuccess: _onLoginSuccess,
              onNavigateToRegister: _navigateToRegister,
            )
          : RegisterPage(
              onRegisterSuccess: _onLoginSuccess,
              onNavigateToLogin: _navigateToLogin,
            );
    }
  }
}

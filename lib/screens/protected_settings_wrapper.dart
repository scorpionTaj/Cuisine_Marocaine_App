import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'settings_screen.dart';
import 'register_page.dart';

class ProtectedSettingsWrapper extends StatefulWidget {
  final ThemeMode themeMode;
  final Color themeColor;
  final Function(bool) onThemeChanged;
  final Function(Color) onColorChanged;

  const ProtectedSettingsWrapper({
    Key? key,
    required this.themeMode,
    required this.themeColor,
    required this.onThemeChanged,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  State<ProtectedSettingsWrapper> createState() =>
      _ProtectedSettingsWrapperState();
}

class _ProtectedSettingsWrapperState extends State<ProtectedSettingsWrapper> {
  bool _isLoggedIn = false;
  bool _loading = true;
  bool _showRegister = false;

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
      _showRegister = false;
    });
  }

  void _toggleRegister() {
    setState(() {
      _showRegister = !_showRegister;
    });
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isLoggedIn) {
      return SettingsScreen(
        currentThemeMode: widget.themeMode,
        currentThemeColor: widget.themeColor,
        onThemeChanged: widget.onThemeChanged,
        onColorChanged: widget.onColorChanged,
        onLogout: _onLogout,
      );
    } else {
      return _showRegister
          ? RegisterPage(
              onRegisterSuccess: _onLoginSuccess,
              onNavigateToLogin: _toggleRegister,
            )
          : LoginPage(
              onLoginSuccess: _onLoginSuccess,
              onNavigateToRegister: _toggleRegister,
            );
    }
  }
}

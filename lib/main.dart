import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/protected_profile_wrapper.dart';
import 'screens/chat_helper_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/responsive_layout.dart';
import 'utils/animations.dart';
import 'services/cache_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Clean expired cache items
  CacheService.cleanExpiredCache();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = AppTheme.primaryViolet;

  @override
  void initState() {
    super.initState();
    _loadThemePreferences();
  }

  Future<void> _loadThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final colorValue = prefs.getInt('primaryColor') ?? AppTheme.primaryViolet.value;

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _primaryColor = Color(colorValue);
    });
  }

  Future<void> _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _changeThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', color.value);
    setState(() {
      _primaryColor = color;
    });
  }

  void _onInitializationComplete() {
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuisine Marocaine App',
      theme: AppTheme.getLightTheme(_primaryColor),
      darkTheme: AppTheme.getDarkTheme(_primaryColor),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: _initialized
          ? MainNavigation(
              themeMode: _themeMode,
              primaryColor: _primaryColor,
              onThemeChanged: _toggleTheme,
              onColorChanged: _changeThemeColor,
            )
          : SplashScreen(
              onInitializationComplete: _onInitializationComplete,
            ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final ThemeMode themeMode;
  final Color primaryColor;
  final Function(bool) onThemeChanged;
  final Function(Color) onColorChanged;

  const MainNavigation({
    Key? key,
    required this.themeMode,
    required this.primaryColor,
    required this.onThemeChanged,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  bool _screensInitialized = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );

    _animationController.forward();
    _initScreens();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeMode != widget.themeMode ||
        oldWidget.primaryColor != widget.primaryColor) {
      _initScreens();
    }
  }

  void _initScreens() {
    if (!_screensInitialized) {
      _screens = List.generate(6, (_) => Container());
      _screensInitialized = true;
    }

    // Only initialize the current screen and adjacent screens
    _initializeScreenAtIndex(_selectedIndex);
    if (_selectedIndex > 0) {
      _initializeScreenAtIndex(_selectedIndex - 1);
    }
    if (_selectedIndex < 5) {
      _initializeScreenAtIndex(_selectedIndex + 1);
    }
  }

  void _initializeScreenAtIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      switch (index) {
        case 0:
          _screens[index] = HomeScreen();
          break;
        case 1:
          _screens[index] = MenuScreen();
          break;
        case 2:
          _screens[index] = ReservationScreen();
          break;
        case 3:
          _screens[index] = ContactScreen();
          break;
        case 4:
          _screens[index] = ProtectedProfileWrapper();
          break;
        case 5:
          _screens[index] = SettingsScreen(
            currentThemeMode: widget.themeMode,
            currentThemeColor: widget.primaryColor,
            onThemeChanged: widget.onThemeChanged,
            onColorChanged: widget.onColorChanged,
            onLogout: () {
              // Handle logout in the profile screen
            },
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cuisine Marocaine App',
          style: TextStyle(
            fontSize: ResponsiveLayout.getFontSize(context, 20),
          ),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            AppAnimations.pageRouteBuilder(ChatHelperScreen()),
          );
        },
        child: const Icon(Icons.chat),
        tooltip: 'Assistant Culinaire',
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex != index) {
            _animationController.reset();
            setState(() => _selectedIndex = index);
            _initializeScreenAtIndex(index);
            _animationController.forward();
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Réservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}

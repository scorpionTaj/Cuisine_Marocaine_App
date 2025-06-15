import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Color currentThemeColor;
  final Function(bool) onThemeChanged;
  final Function(Color) onColorChanged;
  final VoidCallback? onLogout;

  const SettingsScreen({
    Key? key,
    required this.currentThemeMode,
    required this.currentThemeColor,
    required this.onThemeChanged,
    required this.onColorChanged,
    this.onLogout,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _username = '';

  final List<ThemeColorOption> themeColors = [
    ThemeColorOption('Violet', const Color(0xFF7C3AED)),
    ThemeColorOption('Rouge', Colors.red),
    ThemeColorOption('Bleu', Colors.blue),
    ThemeColorOption('Vert', Colors.green),
    ThemeColorOption('Orange', Colors.orange),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentThemeMode != oldWidget.currentThemeMode ||
        widget.currentThemeColor != oldWidget.currentThemeColor) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paramètres',
              style: GoogleFonts.cairo(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // User info card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connecté en tant que',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      _username,
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: widget.onLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Theme settings
            Text(
              'Apparence',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Dark mode switch
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mode Sombre',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          widget.currentThemeMode == ThemeMode.dark
                              ? Icons.nightlight_round
                              : Icons.wb_sunny,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: widget.currentThemeMode == ThemeMode.dark,
                          onChanged: widget.onThemeChanged,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Theme color options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Couleur du thème',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: themeColors.map((colorOption) {
                        final bool isSelected = colorOption.color.value == widget.currentThemeColor.value;
                        return GestureDetector(
                          onTap: () => widget.onColorChanged(colorOption.color),
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: colorOption.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                      ? Theme.of(context).colorScheme.onBackground
                                      : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(colorOption.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'À propos',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Version'),
                      subtitle: const Text('1.0.0'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.restaurant, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Cuisine Marocaine App'),
                      subtitle: const Text('© 2025 Tous droits réservés'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

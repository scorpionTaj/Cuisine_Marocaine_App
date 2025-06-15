import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  const ProfileScreen({Key? key, this.onLogout}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Simuler des plats favoris (mock)
  final List<String> _platsFavoris = [
    'Tajine de poulet',
    'Couscous royal',
    'Harira',
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    _emailController.dispose();
    super.dispose();
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
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mon Profil',
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _prenomController,
              decoration: InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _telController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Mes plats favoris',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ..._platsFavoris.map(
              (plat) => Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text(plat, style: GoogleFonts.cairo()),
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.help_outline),
                    label: Text('Aide', style: GoogleFonts.cairo()),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (widget.onLogout != null) widget.onLogout!();
                      // Nettoyer la session
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', false);
                      await prefs.remove('username');
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Se déconnecter', style: GoogleFonts.cairo()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // helper function to launch URLs
  Future<void> _launchUri(Uri uri, BuildContext context) async {
    try {
      if (!await launchUrl(uri)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir ${uri.toString()}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Section
          Text(
            'À Propos de Nous',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Notre Histoire',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Restaurant Marocain a été fondé en 2003 par le Chef Youssef El Fassi, passionné de cuisine marocaine traditionnelle. Notre mission est de vous offrir une expérience culinaire authentique du Maroc dans un cadre élégant et chaleureux.\n\nNous sélectionnons nos produits auprès de fournisseurs locaux et privilégions les épices et ingrédients marocains pour garantir la fraîcheur et la qualité de nos plats.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Contact Information
          Text(
            'Nous Contacter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Adresse'),
                  subtitle: const Text('FS , Mekens'),
                  isThreeLine: true,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
                  title: const Text('Téléphone'),
                  subtitle: const Text('+212690018054'),
                  onTap: () => _launchUri(Uri(scheme: 'tel', path: '+212690018054'), context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
                  title: const Text('Email'),
                  subtitle: const Text('contact@restaurant-marocain.ma'),
                  onTap: () => _launchUri(Uri(scheme: 'mailto', path: 'contact@restaurant-marocain.ma'), context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
                  title: const Text('Site Web'),
                  subtitle: const Text('www.restaurant-marocain.ma'),
                  onTap: () => _launchUri(Uri(scheme: 'https', host: 'www.restaurant-marocain.ma'), context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Reservation Section
          Text(
            'Réservation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Réservez votre table',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pour réserver une table, contactez-nous par téléphone ou par email. '
                    'Nous recommandons de réserver à l\'avance, surtout pour les weekends '
                    'et les soirées.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUri(Uri(scheme: 'tel', path: '+212690018054'), context),
                          icon: const Icon(Icons.phone),
                          label: const Text('Appeler'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUri(Uri(scheme: 'mailto', path: 'contact@restaurant-marocain.ma'), context),
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Team Section
          Text(
            'Notre Équipe',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTeamMember(
                    context,
                    'Imad el khelyfy',
                    'Chef Exécutif',
                    'Spécialiste des saveurs marocaines et des recettes traditionnelles',
                    Icons.person,
                  ),
                  const Divider(),
                  _buildTeamMember(
                    context,
                    'Tajeddine Bourhim',
                    'Pâtissière',
                    'Maîtresse des douceurs orientales et pâtisseries marocaines',
                    Icons.cake,
                  ),
                  const Divider(),
                  _buildTeamMember(
                    context,
                    'Mohammed Eddihe ',
                    'Responsable de salle',
                    'Garant de votre expérience marocaine authentique',
                    Icons.emoji_people,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Social Media Section
          Text(
            'Suivez-nous',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    context,
                    Icons.facebook,
                    'Facebook',
                    Colors.blue.shade800,
                  ),
                  _buildSocialButton(
                    context,
                    Icons.camera_alt,
                    'Instagram',
                    Colors.purple.shade800,
                  ),
                  _buildSocialButton(
                    context,
                    Icons.star,
                    'TripAdvisor',
                    Colors.green.shade800,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, String name, String role,
      String description, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      BuildContext context, IconData icon, String platform, Color color) {
    // Determine which URL to launch based on platform
    Uri getLaunchUrl() {
      switch (platform) {
        case 'Facebook':
          return Uri.parse('https://www.facebook.com/restaurantmarocain');
        case 'Instagram':
          return Uri.parse('https://www.instagram.com/restaurantmarocain');
        case 'TripAdvisor':
          return Uri.parse('https://www.tripadvisor.com/Restaurant_Review-restaurantmarocain');
        default:
          return Uri.parse('https://www.restaurant-marocain.ma');
      }
    }

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: () {
              _launchUri(getLaunchUrl(), context);
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          platform,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo image replaces the icon
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenue chez Dar Tajine, un restaurant marocain authentique qui vous plonge dans les saveurs de la médina. Depuis plus de 20 ans, nous servons des plats traditionnels marocains préparés avec des ingrédients frais et des épices locales.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Découvrez la richesse de la cuisine marocaine authentique dans une ambiance chaleureuse et conviviale. '
                    'Nous vous proposons des plats traditionnels marocains préparés avec des ingrédients frais et des épices raffinées : couscous, tajines, pastilla, pâtisseries orientales et bien plus encore.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Restaurant Info Section
          Text(
            'Informations du Restaurant',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          // Address Card
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on,
                  color: Theme.of(context).primaryColor),
              title: const Text('Adresse'),
              subtitle: const Text('123 Avenue Mohammed V\n10000 Rabat, Maroc'),
              isThreeLine: true,
            ),
          ),

          const SizedBox(height: 12),

          // Phone Card
          Card(
            child: ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: const Text('Téléphone'),
              subtitle: const Text('+212 5 37 77 77 77'),
            ),
          ),

          const SizedBox(height: 12),

          // Email Card
          Card(
            child: ListTile(
              leading: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              title: const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('contact@saveur-restaurant.fr'),
            ),
          ),

          const SizedBox(height: 20),

          // Opening Hours Section
          Text(
            'Horaires d\'ouverture',
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
                  _buildOpeningHour(context, 'Lundi - Vendredi',
                      '12h00 - 14h30\n19h00 - 22h30'),
                  const Divider(),
                  _buildOpeningHour(
                      context, 'Samedi', '12h00 - 15h00\n19h00 - 23h00'),
                  const Divider(),
                  _buildOpeningHour(
                      context, 'Dimanche', '12h00 - 15h00\n19h00 - 22h00'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Special Features Section
          Text(
            'Nos Spécialités',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_dining,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cuisine\nTraditionnelle',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.eco,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Produits\nFrais',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.wine_bar,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cave à\nVins',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHour(BuildContext context, String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          hours,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

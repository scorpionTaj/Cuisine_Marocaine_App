import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/data_service.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'Entrées marocaines',
    'Tajines et Couscous',
    'Douceurs marocaines',
    'Boissons locales',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadMenuItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMenuItems() async {
    try {
      final items = await DataService.getMenuItems();
      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors du chargement du menu')),
      );
    }
  }

  Future<void> _refreshMenu() async {
    setState(() {
      _isLoading = true;
    });
    await _loadMenuItems();
  }

  List<MenuItem> _getItemsByCategory(String category) {
    return _menuItems.where((item) => item.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: _categories.map((category) => Tab(text: category)).toList(),
          ),
        ),

        // Tab Bar View
        Expanded(
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Chargement du menu...'),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    final categoryItems = _getItemsByCategory(category);

                    if (categoryItems.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun plat disponible\ndans cette catégorie',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshMenu,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: categoryItems.length,
                        itemBuilder: (context, index) {
                          return MenuItemCard(
                            menuItem: categoryItems[index],
                            onUpdate: _refreshMenu,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

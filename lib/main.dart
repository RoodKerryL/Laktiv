import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; 
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/about_screen.dart';


void main() {
  runApp(const LakResetApp());
}

class LakResetApp extends StatelessWidget {
  const LakResetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LAKResèt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const SplashScreen(), 
    );
  }
}

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;
  final GlobalKey<FavoritesScreenState> _favoritesKey = GlobalKey<FavoritesScreenState>();
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        key: _homeKey,
        onFavoriteChanged: () {
          // Recharger la liste des favoris quand un favori est ajouté/retiré depuis Home
          _favoritesKey.currentState?.loadFavorites();
        },
      ),
      FavoritesScreen(
        key: _favoritesKey,
        onFavoriteChanged: () {
          // Recharger les IDs des favoris quand un favori est retiré depuis Favorites
          _homeKey.currentState?.loadFavoriteIds();
        },
      ),
      const AboutScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Recharger les données quand on change d'onglet
    if (index == 1) {
      // Quand on va sur l'onglet Favoris, recharger la liste
      _favoritesKey.currentState?.loadFavorites();
    } else if (index == 0) {
      // Quand on revient sur l'onglet Home, recharger les IDs des favoris
      _homeKey.currentState?.loadFavoriteIds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Resèt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Apwopo',
          ),
        ],
      ),
    );
  }
}
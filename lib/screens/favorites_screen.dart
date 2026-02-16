import 'package:flutter/material.dart';
import 'package:lakreset/favorites%20service.dart';
import 'package:lakreset/models.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback? onFavoriteChanged;
  
  const FavoritesScreen({super.key, this.onFavoriteChanged});

  @override
  State<FavoritesScreen> createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<Recettes> _favoriteRecettes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    setState(() => _isLoading = true);

    final favorites = await FavoritesService.getFavorites();

    if (mounted) {
      setState(() {
        _favoriteRecettes = favorites;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Recettes recette) async {
    final wasRemoved = await FavoritesService.removeFavorite(recette.id);
    
    if (!wasRemoved) return;
    
    if (mounted) {
      setState(() {
        _favoriteRecettes.removeWhere((r) => r.id == recette.id);
      });

      widget.onFavoriteChanged?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${recette.name} retire nan favori'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favori",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Colors.orange[800],
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteRecettes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Poko gen favori',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text('Ajoute kèk resèt nan favori ou!',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _favoriteRecettes.length,
                    itemBuilder: (context, index) {
                      final Recette = _favoriteRecettes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(
                                  Recette: Recette,
                                  isFromFavorites: true,
                                  onFavoriteChanged: () {
                                    loadFavorites();
                                    widget.onFavoriteChanged?.call();
                                  },
                                ),
                              ),
                            );
                            
                            if (result == true) {
                              loadFavorites();
                            }
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                child: Image.network(
                                  Recette.image,
                                  width: 110,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 110,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    Recette.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: const Icon(Icons.favorite, color: Colors.red, size: 28),
                                  onPressed: () => _removeFavorite(Recette),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
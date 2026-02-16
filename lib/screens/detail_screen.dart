import 'package:flutter/material.dart';
import 'package:lakreset/favorites_service.dart';
import 'package:lakreset/models.dart';

class DetailScreen extends StatefulWidget {
  final Recettes Recette;
  final bool isFromFavorites;
  final VoidCallback? onFavoriteChanged;

  const DetailScreen({
    super.key,
    required this.Recette,
    this.isFromFavorites = false,
    this.onFavoriteChanged,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorite = await FavoritesService.isFavorite(widget.Recette.id);
    
    if (mounted) {
      setState(() {
        isFavorite = favorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final wasToggled = await FavoritesService.toggleFavorite(widget.Recette);
    
    if (!wasToggled) return;

    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
      });

      widget.onFavoriteChanged?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite 
                ? '${widget.Recette.name} ajoute nan favori'
                : '${widget.Recette.name} retire nan favori'
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      if (widget.isFromFavorites && !isFavorite) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Recette.name),
        backgroundColor: Colors.orange[800],
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.Recette.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 64, color: Colors.grey),
                    );
                  },
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    widget.Recette.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Engredyan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (widget.Recette.ingredients.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Pa gen engredyan disponib',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...widget.Recette.ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ingredient,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 25),

                  const Text(
                    'Etap preparasyon',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (widget.Recette.instructions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Pa gen enstriksyon disponib',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...widget.Recette.instructions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String instruction = entry.value;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.orange[800],
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                instruction,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}